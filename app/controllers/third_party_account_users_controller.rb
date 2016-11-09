class ThirdPartyAccountUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def third_party_account_sign_in
    @user = AppUser.find_by(account_name: params[:userID])
    if @user
      @user.update_attribute(:token, params[:token])
      result = {"createuser":"user_exists", "created_id":@user[:user_id].to_s}
    else
      created_id = AppUser.create_new_app_user_with_third_party_account(params)
      result = {"createuser":"user_created", "created_id":created_id.to_s}
    end
    render json: result
  end

end
