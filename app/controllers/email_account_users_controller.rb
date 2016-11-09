class EmailAccountUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def email_account_sign_up
    if AppUser.account_exist params[:email].downcase
      result = {"createuser":"user_exists"}
    else
      created_result = AppUser.create_new_app_user_with_email(params)
      activation_url = 'http://'+ $host +'/account_activations/' + created_result[:token] +
       '/edit?email=' + params[:email].downcase.split('@')[0] + '%40' + params[:email].downcase.split('@')[1]
      EmailMailer.welcome_email(activation_url, params[:email].downcase.downcase).deliver_later
      result = {"createuser":"user_created", "created_id":created_result[:id].to_s}
    end
    render json: result
  end

  def email_account_login
    @aim_user = AppUser.find_by(account_name:params[:email].downcase)
    if @aim_user && params[:password].eql?(@aim_user[:password])
      @aim_user.update_attribute(:token, SecureRandom.urlsafe_base64)
      result = {"login":true, "token":@aim_user[:token], "user_id":@aim_user[:user_id].to_s}
    else
      result = {"login":false}
    end
    render json: result
  end

  def email_account_reset_password
    @aim_user = AppUser.find_by(account_name:params[:email].downcase)
    if @aim_user
      @aim_user.update_attribute(:reset_token, SecureRandom.urlsafe_base64)
      @aim_user.update_attribute(:reset_token_generated_time, DateTime.now + 1.hour)
      reset_url = 'http://'+ $host +'/pw_resetters/' + @aim_user[:reset_token] +
       '/edit?email=' + @aim_user[:email].split('@')[0] + '%40' + @aim_user[:email].split('@')[1]
      EmailMailer.reset_password_email(reset_url, @aim_user[:email].downcase).deliver_later
      result = {"reset_request":true}
    else
      result = {"reset_request":false}
    end
    render json: result
  end
end
