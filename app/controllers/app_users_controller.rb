class AppUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  require 'find'
  require 'socket'

  #[ROOT]
  def home
    puts "!!!!!!!!!!!!!!!!!!!!"
    puts "@@@@@@@@@@@@@@@@@@@@"

=begin
    #查询时同时加载其关联元组
    temp = PairingInfo.includes(:app_user).first()
=end

=begin
    #通过连google的服务器，动态获取服务器自身ip
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
    # 用过用户id来锁定用户
    @aim_user = AppUser.find_by(user_id: params[:user_id])
    if !@aim_user
      result = {"result":false, "error":3}
    elsif !@aim_user[:token].eql?(params[:token])
      result = {"result":false, "error":2}
    elsif @aim_user[:name].empty?
      result = {"result":false, "error":1}
    else
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
    #         avatar:string avatar_format:string first_frame:string
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
    # params: user_id:int images:[content:string, content_format:string,
    #         first_frame:string, first_frame_format:string]
    image_count = 0
    #name_list = []
    #名字重复覆盖（如果仅仅检查，重复后还是要改）
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

#####改项目######################################################################
  def fetch_my_info
    result = AppUser.fetch_my_info(params[:user_id])
    path = "./app_users_images/#{result[:user_id]}"
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
    render json: result
  end

  def manage_my_account
    AppUser.update_my_account params
    result = {"result":true, "error":""}
    render json: result
  end

  def update_my_avatar
    @aim_user = AppUser.find_by(user_id: params[:user_id].to_i)
    @aim_user.update_attribute(:avatar, "app_users_images/#{params[:user_id]}/#{params[:avatar]}")
    result = {"result":"avatar_updated" }
    render json: result
  end

  def delete_image
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
