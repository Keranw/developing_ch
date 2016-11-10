class AppUser < ApplicationRecord

  def self.account_exist(test_account_name)
    AppUser.exists?(account_name: test_account_name)
  end

  def self.create_new_app_user_with_email(params)
    @new_user = AppUser.new
    @new_user[:user_id] = AppUser.maximum(:id).to_i.next + 10000
    @new_user[:account_name] = params[:email].downcase
    @new_user[:password] = params[:password]
    @new_user[:email] = params[:email].downcase
    @new_user[:account_type] = 'Email'
    @new_user[:activation_token] = SecureRandom.urlsafe_base64
    @new_user[:reset_token_generated_time] = DateTime.now
    @new_user.save!
    {:id => @new_user[:user_id], :token => @new_user[:activation_token]}
  end

  def self.create_new_app_user_with_third_party_account(params)
    @new_user = AppUser.new
    @new_user[:user_id] = AppUser.maximum(:id).to_i.next + 10000
    @new_user[:account_name] = params[:userID]
    @new_user[:token] = params[:token]
    @new_user[:email] = params[:email]
    @new_user[:account_type] = params[:source]
    @new_user[:activated] = true
    @new_user.save!
    @new_user[:user_id]
  end

  def self.update_my_account(params)
    @aim_user = AppUser.find_by(user_id: params[:user_id].to_i)
    @aim_user[:email] = params[:email].empty? ? @aim_user[:email] : params[:email].downcase
    @aim_user[:birthday] = params[:birthday].empty? ? @aim_user[:birthday] :
    Time.parse(params[:birthday])
    @aim_user[:avatar] = params[:avatar].empty? ? @aim_user[:avatar] :
    AppUser.upload_image(@aim_user[:user_id], params[:avatar], 0)[0]
    @aim_user[:name] = params[:nickname] || @aim_user[:name]
    @aim_user[:sex] = params[:gender] || @aim_user[:sex]
    @aim_user[:education] = params[:education] || @aim_user[:education]
    @aim_user[:school] = params[:school] || @aim_user[:school]
    @aim_user[:language] = params[:language] || @aim_user[:language]
    @aim_user[:profession] = params[:profession] || @aim_user[:profession]
    @aim_user[:hobby] = params[:hobby] || @aim_user[:hobby]
    @aim_user[:signature] = params[:profession] || @aim_user[:signature]
    @aim_user.save!
  end

  def self.upload_image(user_id, file, tail)
    current_time = Time.now.to_i.to_s + tail.to_s
    FileUtils.mkdir_p "./app_users_images/#{user_id.to_s}"
    image_file = File.new("./app_users_images/#{user_id.to_s}/#{current_time}.jpg", "wb")
    image_file.write(Base64.decode64(file))
    image_file.close
    ["app_users_images/#{user_id}/#{current_time}.jpg", current_time + ".jpg"]
  end

  def self.fetch_my_info(aim_user_id)
    result = {}
    @aim_user = AppUser.find_by(user_id: aim_user_id)
    result[:user_id] = aim_user_id
    result[:account_name] = @aim_user[:account_name]
    result[:account_type] = @aim_user[:account_type]
    result[:email] = @aim_user[:email]
    result[:name] = @aim_user[:name]
    result[:birthday] = @aim_user[:birthday]
    result[:sex] = @aim_user[:sex]
    result[:avatar] = @aim_user[:avatar]
    result[:education] = @aim_user[:education]
    result[:school] = @aim_user[:school]
    result[:language] = @aim_user[:language]
    result[:profession] = @aim_user[:profession]
    result[:hobby] = @aim_user[:hobby]
    result[:signature] = @aim_user[:signature]
    result[:is_vip] = @aim_user[:is_vip]
    result[:vip_purchase_date] = @aim_user[:vip_purchase_date]
    result[:activated] = @aim_user[:activated]
    return result
  end

  def self.fetch_the_origianl_image
  end

  def self.delete_image
  end

  def self.update_my_avatar
  end
end
