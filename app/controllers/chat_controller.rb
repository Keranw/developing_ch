class ChatController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def get_friend_list
    #params user_id:int
    result = PairingInfo.get_friend_list(params[:user_id])
    render json: {friends:result}
  end

  def get_messages
    #parms user_id:int
    result = MessageTemp.get_my_msgs(params[:user_id])
    # 删除已经看过的信息
    # MessageTemp.delete(result)
    render json: {messages:result}
  end

  def new_message
    #params from_id:int to_id:int msg_type:int content:string
    MessageTemp.create_new_msg(params[:from_id], params[:to_id], params[:msg_type], params[:content])
    ##通知to用户
    result = {"result":true}
    render json:result
  end

  def get_temp_image
    # params user_id:int image_name:string
    result = MessageTemp.return_image_content(params[:user_id],params[:image_name])
    ## 还要从文件夹里删除当前图片
    render json: {image:result}
  end
end
