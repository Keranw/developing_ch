class AppUser < ApplicationRecord
  has_one :pairing_info

  def self.create_new_app_user_with_email(params)
    @new_user = AppUser.new
    @new_user[:user_id] = AppUser.maximum(:id).to_i.next + 10000
    #当前email的查重发生在代码里
    @new_user[:account_name] = params[:email]
    @new_user[:account_type] = 'Email'
    @new_user[:password] = params[:password]
    #用户更新用于联系的email，冗余？
    @new_user[:email] = @new_user[:account_name]
    @new_user[:token] = SecureRandom.urlsafe_base64
    #@new_user[:activation_token] = SecureRandom.urlsafe_base64
    @new_user[:reset_token_generated_time] = DateTime.now
    ## B
    @new_user.save!
    # 匹配信息表移出
    {:id => @new_user[:user_id], :token => @new_user[:token], :act_token => @new_user[:activation_token]}
  end

  def self.create_new_app_user_with_third_party_account(params)
    @new_user = AppUser.new
    @new_user[:user_id] = AppUser.maximum(:id).to_i.next + 10000
    @new_user[:account_name] = params[:user_id]
    @new_user[:token] = params[:token]
    @new_user[:email] = params[:email]
    @new_user[:account_type] = params[:source]
    # @new_user[:activated] = true
    ## B
    @new_user.save!
    # 匹配信息表移出
    @new_user[:user_id]
  end

  def self.user_profile_complete(params)
    @aim_user = AppUser.find_by(user_id: params[:user_id])
    @aim_user[:name] = params[:nickname]
    @aim_user[:birthday] = Time.parse(params[:birthday])
    @aim_user[:sex] = params[:sex]
    @aim_user[:not_interest] = params[:sex]
    image_count = 0
    params[:images].each do |f|
      image_count += 1
      AppUser.upload_image(image_count, params[:user_id], f[:first_frame],
        f[:first_frame_format], f[:content], f[:content_format])
    end
    temp = AppUser.upload_image(0, params[:user_id], params[:first_frame],
      params[:first_frame_format], params[:avatar], params[:avatar_format])
    @aim_user[:avatar_frame] = temp[0] # 静图
    @aim_user[:avatar] = temp[1] # 动图
    @aim_user.save!
    #匹配信息表移入
    @new_pairing_info = PairingInfo.new
    @new_pairing_info[:app_user_id] = @aim_user[:id]
    @new_pairing_info[:user_id] = @aim_user[:user_id]
    @new_pairing_info.save!
  end

  def self.upload_image(count, user_id, image_bits, image_format, video_bits, video_format)
    #每调用一次上传一张图片
    current_time = Time.now.to_i.to_s + count.to_s
    image_path = "uploaded_data/avatars/#{user_id}/" + current_time + image_format
    video_path = "uploaded_data/avatars/#{user_id}/" + current_time + video_format
    FileUtils.mkdir_p "uploaded_data/avatars/#{user_id}/"
    AppUser.base64_tranlator(image_path, image_bits)
    AppUser.base64_tranlator(video_path, video_bits)
    temp_aim_user = AppUser.find_by(user_id: user_id)
    temp_aim_user.update_attribute(:avatar_count, temp_aim_user[:avatar_count] += 1)
    [image_path, video_path]
  end

  def self.base64_tranlator(path, content)
    file = File.new(path, "wb")
    file.write(Base64.decode64(content))
    file.close
  end

  def self.fetch_my_info(aim_user_id)
    result = {}
    @aim_user = AppUser.includes(:pairing_info).find_by(user_id: aim_user_id)
    result[:user_id] = aim_user_id
    #result[:account_name] = @aim_user[:account_name]
    #result[:account_type] = @aim_user[:account_type]
    #result[:email] = @aim_user[:email]
    result[:nickname] = @aim_user[:name]
    #result[:birthday] = @aim_user[:birthday]
    #result[:sex] = @aim_user[:sex]
    #result[:avatar] = @aim_user[:avatar]
    #result[:education] = @aim_user[:education]
    result[:first_frame] = Base64.strict_encode64(File.read(@aim_user[:avatar_frame]))
    result[:first_frame_name] = @aim_user[:avatar_frame].split('/').last
    result[:school] = @aim_user[:school]
    result[:language] = @aim_user[:language]
    result[:profession] = @aim_user[:working_area]
    result[:hobby] = @aim_user[:hobby]
    result[:signature] = @aim_user[:signature]
    result[:likes] = @aim_user.pairing_info[:like]
    #result[:is_vip] = @aim_user[:is_vip]
    #result[:vip_purchase_date] = @aim_user[:vip_purchase_date]
    #result[:activated] = @aim_user[:activated]
    return result
  end

  def self.update_my_account(params)
    @aim_user = AppUser.find_by(user_id: params[:user_id])
    #@aim_user[:name] = params[:nickname] || @aim_user[:name]
    #@aim_user[:birthday] = params[:birthday].empty? ? @aim_user[:birthday] :
    #Time.parse(params[:birthday])
    #@aim_user[:sex] = params[:sex] || @aim_user[:sex]
    #@aim_user[:orientation] = params[:orientation] || @aim_user[:orientation]
    #if params[:avatar].empty?||params[:first_frame].empty?
    #else
    #  temp = AppUser.upload_image(params[:user_id], params[:first_frame],
    #    params[:first_frame_format], params[:avatar], params[:avatar_format])
    #  @aim_user[:avatar_frame] = temp[0] # 静图
    #  @aim_user[:avatar] = temp[1] # 动图
    #end
    @aim_user[:school] = params[:school] || @aim_user[:school]
    @aim_user[:language] = params[:language] || @aim_user[:language]
    @aim_user[:working_area] = params[:profession] || @aim_user[:working_area]
    @aim_user[:hobby] = params[:hobby] || @aim_user[:hobby]
    @aim_user[:signature] = params[:signature] || @aim_user[:signature]
    @aim_user.save!
  end

  def self.fetch_my_picture_wall(user_id)
    images = []
    path = "uploaded_data/avatars/#{user_id}/"
    Find.find(path).each do |f|
      # File.directory? // 判断当前
      if File.file?(f) && File.extname(f).eql?(".jpg")
        images << {"picture_name":File.basename(f), "first_frame":Base64.strict_encode64(File.read(f))}
      else
      end
    end
    result = {}
    result[:images] = images
    @current_user = AppUser.includes(:pairing_info).find_by(user_id: user_id.to_i)
    result[:avatar_name] = @current_user[:avatar].split('/').last.split(".").first
    result[:rest_five_names] = @current_user.pairing_info[:rest_five]
    result
  end

  def self.fetch_the_dynamic_image(user_id, image_name)
    path = "uploaded_data/avatars/#{user_id}/" + image_name + ".mp4"
    Base64.strict_encode64(File.read(path))
  end

  def self.update_my_avatar(user_id, video_name, image_name)
    @aim_user = AppUser.includes(:pairing_info).find_by(user_id: user_id.to_i)
    @aim_user[:avatar] = "uploaded_data/avatars/#{user_id}/" + video_name
    @aim_user[:avatar_frame] = "uploaded_data/avatars/#{user_id}/" + image_name
    #再见再也不见
    @aim_user.pairing_info[:met_me] = []
    @aim_user.pairing_info.save!
    @aim_user.save!
  end

  def self.delete_images(user_id, image_names)
    path = "./uploaded_data/avatars/#{:user_id}"
    @aim_pairing_info = PairingInfo.find_by(user_id:user_id)
    image_names.each do |f|
      if @aim_pairing_info[:rest_five].include?(f)
        @aim_pairing_info[:rest_five].delete(f)
      end
      File.delete(f + ".mp4")
      File.delete(f + ".jpg")
    end
    @aim_pairing_info.save!
  end
end
