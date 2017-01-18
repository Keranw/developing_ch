class MessageTemp < ApplicationRecord
  def self.get_my_msgs(user_id)
    @message_set = MessageTemp.where(to_id:user_id.to_i)
=begin
    # 传之前装配好
    @message_set.each do |f|
      if f[:msg_type] == 2
        f[:content] = Base64.strict_encode64(File.read(f[:content]))
      end
    end
=end
    @message_set
  end

  def self.create_new_msg(from_id, to_id, msg_type, content)
    @new_message = MessageTemp.new
    @new_message[:from_id] = from_id.to_i
    @new_message[:to_id] = to_id.to_i
    @new_message[:msg_type] = msg_type
    case msg_type.to_i
    when 2
      @new_message[:content] = MessageTemp.upload_temp_image(content, to_id)
    else
      @new_message[:content] = content
    end
    @new_message.save!
  end

  def self.return_image_content(user_id, image_name)
    path = "uploaded_data/temps/#{user_id}/#{image_name}"
    Base64.strict_encode64(File.read(path))
  end



  def self.upload_temp_image(content, to_id)
    FileUtils.mkdir_p "uploaded_data/temps/#{to_id}/"
    temp_image_name = to_id.to_s + Time.now.to_i.to_s + ".jpg"
    path = "uploaded_data/temps/#{to_id}/" + temp_image_name
    file = File.new(path, "wb")
    file.write(Base64.decode64(content))
    file.close
    temp_image_name
  end
end
