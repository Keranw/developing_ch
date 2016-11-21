class EmailAccountUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def email_account_sign_up
    # params email:string, password:string
    params[:email] = params[:email].downcase
    if AppUser.exists?(account_name: params[:email])
      result = {"result":false, "error":"user_exists", "user_id":"", "token":""}
    else
      created_result = AppUser.create_new_app_user_with_email(params)
=begin
      activation_url = 'http://'+ $host +'/account_activations/' + created_result[:act_token] +
       '/edit?email=' + params[:email].split('@')[0] + '%40' + params[:email].split('@')[1]
      EmailMailer.welcome_email(activation_url, params[:email]).deliver_later
=end
      result = {"result":true, "error":"", "user_id":created_result[:id], "token":created_result[:token]}
    end
    render json: result
  end

  def email_account_login
    # params email:string, password:string
    @aim_user = AppUser.find_by(account_name:params[:email].downcase)
    if !@aim_user
      result = {"result":false, "token":"", "user_id":"", "error":"email_not_valid"}
    elsif !params[:password].eql?(@aim_user[:password])
      result = {"result":false, "token":"", "user_id":"", "error":"password_not_valid"}
    elsif @aim_user[:name].empty?
      @aim_user.update_attribute(:token, SecureRandom.urlsafe_base64)
      result = {"result":false, "token":@aim_user[:token], "user_id":@aim_user[:user_id], "error":"profile_not_complete"}
    else
      @aim_user.update_attribute(:token, SecureRandom.urlsafe_base64)
      result = {"result":true, "token":@aim_user[:token], "user_id":@aim_user[:user_id], "error":""}
    end
    render json: result
  end

  def email_account_reset_password
    # params email:string
    @aim_user = AppUser.find_by(account_name:params[:email].downcase)
    if @aim_user
      @aim_user.update_attribute(:reset_token, SecureRandom.urlsafe_base64)
      @aim_user.update_attribute(:reset_token_generated_time, DateTime.now + 1.hour)
      reset_url = 'http://'+ $host +'/pw_resetters/' + @aim_user[:reset_token] +
       '/edit?email=' + @aim_user[:email].split('@')[0] + '%40' + @aim_user[:email].split('@')[1]
      EmailMailer.reset_password_email(reset_url, @aim_user[:email].downcase).deliver_later
      result = {"result":true, "error":""}
    else
      result = {"result":false, "error":"email_not_valid"}
    end
    render json: result
  end
end
