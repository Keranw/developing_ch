class ThirdPartyAccountUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def third_party_account_sign_in
    # params user_id(account_name):string, token:string, email:string, source:string
    @user = AppUser.find_by(account_name: params[:user_id])
    if !@user
      created_id = AppUser.create_new_app_user_with_third_party_account(params)
      result = {"result":false, "user_id":created_id, "error":"profile_not_complete"}
    elsif @user[:name].empty?
      result = {"result":false, "user_id":@user[:user_id], "error":"profile_not_complete"}
    else
      @user.update_attribute(:token, params[:token])
      result = {"result":true, "user_id":@user[:user_id], "error":""}
    end
    render json: result
  end

end
