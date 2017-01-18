class CreateAppUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :app_users do |t|
    #注册必须数据
      t.integer :user_id
      t.string :account_name
      t.string :password
      t.string :account_type
      t.string :token
    #系统生成辅助数据
      t.string :device_token
      #t.boolean :activated, default: false
      #t.string :activation_token
      t.string :reset_token
      t.datetime :reset_token_generated_time
    #注册额外填写数据
      t.string :name, default: ""
      t.date :birthday
      t.integer :sex # 1代表男，0代表女
      t.string :avatar, default: ""
      t.string :avatar_frame, default: ""
      t.integer :avatar_count, default: 0
      t.integer :not_interest # 1代表男，0代表女，2代表无所谓
    #暂时为空
      t.string :email, default: ""
      t.string :school, default: ""
      t.string :language, default: ""
      t.string :working_area, default: ""
      t.integer :hobby, default: [], array: true
      t.string :signature, default: ""
      t.boolean :is_vip, default: false
      t.date :vip_purchase_date

      t.timestamps
    end
    add_index :app_users, :user_id, unique: true
    #add_index :app_users, :account_name, unique: true => 登录名可改动么？


    #add_index :app_users, :name, unique: true
  end
end
