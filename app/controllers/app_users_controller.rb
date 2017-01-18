class AppUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  #[ROOT]
  def home
    puts "!!!!!!!!!!!!!!!!!!!!"
    puts "@@@@@@@@@@@@@@@@@@@@"

=begin
    #格式化输出JSON
    require 'json'
    puts JSON.pretty_generate(result)
=end

=begin
    #查询时同时加载其关联元组
    temp = PairingInfo.includes(:app_user).first()
=end

=begin
    #通过连google的服务器，动态获取服务器自身ip, 也可以通过域名来解决相应的问题
    local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
=end

=begin
    #输入目标用户的id，把照片墙的内容和用户信息打包
    result = AppUser.fetch_my_info(10001)
    path = "./uploaded_data/avatars/#{result[:user_id]}"
    images = []
    Find.find(path).each do |f|
      # File.directory? // 判断当前
      if File.file?(f) && File.extname(f).eql?(".jpg")
        images << {"#{File.basename(f)}":"123123123"}
      else
      end
    end
    result.store("images", images)
=end
  end
###############################################################################
  def auto_login
    # params: user_id:int, token:string, device_token:string
    # 用过用户id来锁定用户
    @aim_user = AppUser.find_by(user_id: params[:user_id])
    if !@aim_user
      result = {"result":false, "error":3}
    elsif !@aim_user[:token].eql?(params[:token])
      result = {"result":false, "error":2}
    elsif @aim_user[:name].empty?
      result = {"result":false, "error":1}
    else
      @aim_user.update_attribute(:device_token, params[:device_token])
      result = {"result":true, "error":""}
    end
    render json: result
  end

  def check_nickname_existence
    # params: nickname:string
    if !AppUser.exists?(name: params[:nickname])
      result = {"result": true, "error":""}
    else
      result = {"result": false, "error":1}
    end
    render json: result
  end

  def user_profile_complete
    # params: user_id:int nickname:string birthday:string sex:int
    #         avatar:string avatar_format:string first_frame:string,
    #         first_frame_format:string images:[content:string,
    #         content_format:string, first_frame:string,
    #         first_frame_format:string]
    AppUser.user_profile_complete params
    if AppUser.find_by(user_id: params[:user_id])[:name].empty?
      result = {"result":false, "error":"update_failed"}
    else
      result = {"result":true, "error":""}
    end
    render json: result
  end

  def upload_image
    # 上传多张第三类图片
    # params: user_id:int images:[content:string, content_format:string,
    #         first_frame:string, first_frame_format:string]
    image_count = 0
    #name_list = []
    # 名字重复覆盖（如果仅仅检查，重复后还是要改）
    params[:images].each do |f|
      image_count += 1
      AppUser.upload_image(image_count, params[:user_id], f[:first_frame],
      f[:first_frame_format], f[:content], f[:content_format])
      #name_list << {f.name, image_new_time} # 传过来的名字，改过的名字
    end
    result = {"result":true, "error":""
              #, "name_list":name_list #告知当前文件名
              }
    render json: result
  end

  def fetch_my_info
    # params: user_id:int
    result = AppUser.fetch_my_info(params[:user_id])
=begin
    images = []
    if File.directory?(path)
      Find.find(path).each do |f|
        # 预防图片硬转不了，如果是png则无法解决
        if File.file?(f) && File.extname(f).eql?(".jpg")
          images << {"#{File.basename(f)}":Base64.strict_encode64(File.read(f))}
        else
        end
      end
      result.store("images", images)
    else
    end
=end
    render json: result
  end

  def manage_my_account
    # params language:string school:string profession:string hobby:int[]
    #        signature:string
    AppUser.update_my_account params
    result = {"result":true, "error":""}
    render json: result
  end

  def update_my_avatar
    # params user_id:int avatar_name:string
    AppUser.update_my_avatar(params[:user_id], params[:avatar_name]+".mp4",
            params[:avatar_name] + ".jpg")
    result = {"result":true, "error":""}
    render json: result
  end

  def fetch_my_picture_wall
    # params user_id:int
    result = AppUser.fetch_my_picture_wall(params[:user_id])
    render json: result
  end

  def fetch_the_dynamic_image
    # params user_id:int image_name:string
    result = AppUser.fetch_the_dynamic_image(params[:user_id], params[:image_name])
    render json: {image:result}
  end

  def update_my_rest_five
    #params user_id rest_five_images:string[]
    @aim_pairing_info = PairingInfo.find_by(user_id:params[:user_id])
    @aim_pairing_info.update_attribute(:rest_five, params[:rest_five_images])
    result = {"result":true, "error":""}
    render json: result
  end

  def delete_image
    # params user_id:int image_names:string[]
    AppUser.delete_images(params[:user_id], params[:image_names])
    result = {"result":true, "error":""}
    render json: result
  end
end
