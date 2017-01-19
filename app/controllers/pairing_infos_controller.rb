class PairingInfosController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def get_more_profiles_without_gps
    # params user_id:int
    result = PairingInfo.return_profile_without_gps(params[:user_id])
    render json: {profiles:result}
  end

  def get_more_profiles_with_gps ##
    # params user_id:int latitude:double longitude:double postcode:int
    PairingInfo.update_my_gps_info(params[:user_id], params[:latitude], params[:longitude], params[:postcode])
    result = PairingInfo.return_profile_with_gps(params[:user_id], params[:postcode])
    render json: {profiles:result}
  end

  def update_pair_result
    # params user_id:int aim_id:int result:boolean
    PairingInfo.update_pair_result(params[:user_id], params[:aim_id], params[:result])
    result = {"result":true, "error":""}
    render json: result
  end

  def update_like_result
    # params user_id:int aim_id:int result:boolean
    PairingInfo.update_like_result(params[:user_id], params[:aim_id], params[:result])
    result = {"result":true, "error":""}
    render json: result
  end

  def get_like_me_profiles
    # params user_id:int
    result = PairingInfo.return_like_me_profiles(params[:user_id])
    render json: {profiles:result}
  end

  def get_rest_dynamic_photos
    # params aim_id:int
    result = PairingInfo.return_rest_five_images(params[:aim_id])
    render json: {dynamic_photos:result}
  end
end
