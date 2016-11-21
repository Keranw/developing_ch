class PwResettersController < ApplicationController
  def edit
    #params email:string, reset_token:string
    @aim_user = AppUser.find_by(account_name: params[:email])
    if @aim_user && params[:id].eql?(@aim_user[:reset_token]) && @aim_user[:reset_token_generated_time] > DateTime.now
    else
      render 'error'
    end
  end

###############################################################
  def done
    #params reset_info:hash
    @aim_user = AppUser.find_by(account_name: params[:reset_info][:email])
    reset_url = 'http://'+ $host +'/pw_resetters/' + @aim_user[:reset_token] +
     '/edit?email=' + @aim_user[:account_name].split('@')[0] + '%40' + @aim_user[:account_name].split('@')[1]
    same = params[:reset_info][:password].eql?(params[:reset_info][:password_confirmation])
    length = params[:reset_info][:password].length > 5
    if same && length
      @aim_user.update_attribute(:password, params[:reset_info][:password].to_s)
      @aim_user.update_attribute(:reset_token_generated_time, DateTime.now)
    elsif same
      flash[:reset_error] = "The password should be 6 characters at least."
      redirect_to reset_url
    else
      flash[:reset_error] = "Passwords don't match."
      redirect_to reset_url
    end
  end

  def error
  end
end
