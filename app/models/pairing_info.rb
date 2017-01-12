class PairingInfo < ApplicationRecord
  belongs_to :app_user

  def self.return_profile_without_gps(user_id)
    result = []
    @current_user = AppUser.find_by(user_id: user_id.to_i)
    temp_list = AppUser.where("birthday is not null").order("updated_at desc").to_a
    temp_list.delete(@current_user)
    #.limit(20)
    temp_list.each do |f|
      if !f.pairing_info[:met_me].include?(@current_user[:user_id]) &&
        !f[:sex].eql?(@current_user[:not_interest])
        result.push(PairingInfo.assemble_profile_json_without_gps(f))
      end
      break if result.length > 19
    end
    result
  end
  def self.assemble_profile_json_without_gps(user_info)
    result = {}
    result[:user_id] = user_info[:user_id]
    result[:nickname] = user_info[:name]
    result[:dynamic_picture_amount] = user_info[:avatar_count]
    result[:dynamic_picture] = Base64.strict_encode64(File.read(user_info[:avatar]))
    result[:first_frame] = Base64.strict_encode64(File.read(user_info[:avatar_frame]))
    result[:dynamic_picture_name] = user_info[:avatar].split('/').last
    result
  end

  def self.return_profile_with_gps(user_id, user_postcode)
    result = []
    @current_user = AppUser.find_by(user_id: user_id.to_i)
    temp_list_1 = PairingInfo.where(:postcode => user_postcode.to_i).to_a
    temp_list = temp_list_1 - [@current_user.pairing_info]
    temp_list.each do |f|
      if !f[:met_me].include?(@current_user[:user_id]) &&
        !f.app_user[:sex].eql?(@current_user[:not_interest])
        result.push(PairingInfo.assemble_profile_json_with_gps(f.app_user, f))
      end
      break if result.length > 19
    end
    if result.length < 20
      #直接驻扎SQL语句
      #temp_list_2 = PairingInfo.where("postcode < (#{user_postcode}+5) AND postcode > (#{user_postcode}-5)")
      temp_list_2 = PairingInfo.order("updated_at desc").to_a
      temp_list = temp_list_2 - temp_list_1
      temp_list.each do |f|
        if !f[:met_me].include?(@current_user[:user_id]) &&
          !f.app_user[:sex].eql?(@current_user[:not_interest])
          result.push(PairingInfo.assemble_profile_json_with_gps(f.app_user, f))
        end
        break if result.length > 19
      end
    end
    result
  end
  def self.assemble_profile_json_with_gps(user_info, pairing_info)
    result = {}
    result[:user_id] = user_info[:user_id]
    result[:nickname] = user_info[:name]
    result[:longitude] = pairing_info[:longitude]
    result[:latitude] = pairing_info[:latitude]
    result[:dynamic_picture_name] = user_info[:avatar].split('/').last
    result[:dynamic_picture_amount] = user_info[:avatar_count]
    result[:dynamic_picture] = Base64.strict_encode64(File.read(user_info[:avatar]))
    result[:first_frame] = Base64.strict_encode64(File.read(user_info[:avatar_frame]))
    result
  end

  def self.update_my_gps_info(user_id, latitude, longitude, postcode)
    @aim_pairing_info = PairingInfo.find_by(user_id: user_id.to_i)
    @aim_pairing_info[:postcode] = postcode.to_i
    @aim_pairing_info[:longitude] = longitude.to_f
    @aim_pairing_info[:latitude] = latitude.to_f
    @aim_pairing_info.save!
  end

#################################################################
  def self.update_pair_result(user_id, aim_id, result)
    @aim_pairing_info = PairingInfo.find_by(user_id: aim_id)
    @aim_pairing_info[:met_me].push(user_id)
    #模拟器不分布尔和字符串
    if result == true || result == "true"
      @aim_pairing_info[:like] += 1
      if !@aim_pairing_info[:like_list].include?(user_id)
        @aim_pairing_info[:like_list].push(user_id)
      end
    else
      @aim_pairing_info[:dislike] += 1
    end
    @aim_pairing_info.save!
  end

end
