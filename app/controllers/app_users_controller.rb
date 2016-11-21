class AppUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  require 'find'
  require 'socket'

  #[ROOT]
  def home
    puts "!!!!!!!!!!!!!!!!!!!!"

    puts "@@@@@@@@@@@@@@@@@@@@"
=begin
    #通过连google的服务器获取本地服务器ip
    local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
=end

=begin
    #输入目标用户的id，把照片墙的内容和用户信息打包
    result = AppUser.fetch_my_info(10001)
    path = "./app_users_images/#{result[:user_id]}"
    images = []
    Find.find(path).each do |f|
      # File.directory? // 判断当前
      if File.file?(f) && File.extname(f).eql?(".jpg")
        images << {"#{File.basename(f)}":"123123123"}
      else
      end
    end
    result.store("images", images)
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts result.inspect
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
=end
  end

  def experiment
    puts '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    puts params.inspect
    puts '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
  end
###############################################################################
  def auto_login
    # params: user_id:int, token:string
    @aim_user = AppUser.find_by(user_id: params[:user_id])
    if !@aim_user[:token].eql?(params[:token])
      result = {"result":false, "error":"token_not_valid"}
    elsif @aim_user[:name].empty?
      result = {"result":false, "error":"profile_not_complete"}
    else
      result = {"result":true, "error":""}
    end
    render json: result
  end

  def check_nickname_exist
    # params: nickname
    if !AppUser.exists?(name: params[:nickname])
      result = {"result": true, "error":""}
    else
      result = {"result": false, "error":"nickname_exists"}
    end
    render json: result
  end



  def manage_my_account
    AppUser.update_my_account params
    result = {"result":true, "error":""}
    render json: result
  end

  def upload_image
    #还存在照片墙缩略图问题
    count = 0
    name_list = []
    params[:pictureWall].each do |f|
      temp = {}
      temp.store(f[:name], AppUser.upload_image(params[:user_id], f[:imageContent], count+=1)[1])
      name_list << temp
    end
    result = {"result":"image_uploaded", "name_list":name_list}
    render json: result
  end

  def update_my_avatar
    @aim_user = AppUser.find_by(user_id: params[:user_id].to_i)
    @aim_user.update_attribute(:avatar, "app_users_images/#{params[:user_id]}/#{params[:avatar]}")
    result = {"result":"avatar_updated" }
    render json: result
  end

  def fetch_my_info
    result = AppUser.fetch_my_info(params[:user_id])
    path = "./app_users_images/#{result[:user_id]}"
    images = []
    if File.directory?(path)
      Find.find(path).each do |f|
        if File.file?(f) && File.extname(f).eql?(".jpg")
          images << {"#{File.basename(f)}":Base64.strict_encode64(File.read(f))}
        else
        end
      end
      result.store("images", images)
    else
    end
    render json: result
  end

  def delete_image ############################################
    # 需要数据：用户id，删除目标，当前假定删除多张图片
    # 目录不存在的问题
    path = "./app_users_images/#{params[:user_id]}"
    puts params
    Find.find(path).each do |f|
      if File.file?(f) && File.extname(f).eql?(".jpg")
        #删除图片
        puts File.basename(f)
      else
        #跳过去不管
      end
    end
    result = {"aaa":"123"}
    render json: result
  end
end
