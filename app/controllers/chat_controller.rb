class ChatController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def get_friend_list
    #params user_id:int
    result = PairingInfo.get_friend_list(params[:user_id].to_i)
    render json: {friends:result}
  end

  def get_messages
    #parms user_id:int
    result = MessageTemp.get_my_msgs(params[:user_id])
    render json: {messages:result}
    # 删除已经看过的信息
    MessageTemp.delete(result)
  end

  def get_friend_messages
    #params user_id:int friend_id:int
    result = MessageTemp.get_friend_messages(params[:user_id],params[:friend_id])
    render json: {messages:result}
    # 删除已经看过的信息
    MessageTemp.delete(result)
  end

  def new_message
    #params from_id:int to_id:int msg_type:int content:string
    @temp_user = PairingInfo.find_by(user_id:params[:to_id])
    if @temp_user[:friend_list].include?(params[:from_id])
      MessageTemp.create_new_msg(params[:from_id], params[:to_id], params[:msg_type], params[:content])
      result = {"result":true}
      render json:result
      #通知to用户
      MessageTemp.push_a_msg(params[:to_id])
    else
      result = {"result":false}
      render json:result
    end
  end

  def get_temp_image
    # params user_id:int image_name:string
    result = MessageTemp.return_image_content(params[:user_id],params[:image_name])
    ## 还要从文件夹里删除当前图片
    render json: {image:result}
  end
end
