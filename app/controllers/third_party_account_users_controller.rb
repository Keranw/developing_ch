class ThirdPartyAccountUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def third_party_account_sign_in ##
    # params user_id(account_name):string, token:string, email:string,
    #        source:string, device_token:string
    ## B
    @aim_user = AppUser.find_by(account_name: params[:user_id])
    if !@aim_user
      created_id = AppUser.create_new_app_user_with_third_party_account(params)
      result = {"result":false, "user_id":created_id, "error":1}
    elsif @aim_user[:name].empty?
      result = {"result":false, "user_id":@aim_user[:user_id], "error":1}
    else
      @aim_user.update_attribute(:token, params[:token])
      @aim_user.update_attribute(:device_token, params[:device_token])
      result = {"result":true, "user_id":@aim_user[:user_id], "error":""}
    end
    render json: result
  end

end
