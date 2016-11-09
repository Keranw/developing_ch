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
    #输入目标用户的id，把照片墙的内容打包
    result = AppUser.fetch_my_info(10001)
    path = "./app_users_images/#{result[:user_id]}"
    images = []
    Find.find(path).each do |f|
      if File.file?(f) && File.extname(f).eql?(".jpg")
        #生成图片缩略图
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

  def manage_my_account
    AppUser.update_my_account params
    result = {"result":"info_updated"}
    render json: result
  end

  def upload_image
    #还存在照片墙缩略图问题
    count = 0
    params[:pictureWall].each do |f|
      AppUser.upload_image(params[:user_id], f[:imageContent], count+=1)
    end
    result = {"result":"image_uploaded"}
    render json: result
  end

  def delete_image
  end

  def update_my_avatar
  end
end
