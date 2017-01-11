class AccountActivationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  #激活功能暂时被阉割
  def activate
    # params email(account_name):string activation_token:string
    @aim_user = AppUser.find_by(account_name: params[:email])
    if @aim_user && @aim_user[:activated] == false && params[:id].eql?(@aim_user[:activation_token])
      @aim_user.update_attribute(:activated, true)
      render 'done'
    else
      render 'error'
    end
  end

########################################################################################
  def done
  end

  def error
  end
end
