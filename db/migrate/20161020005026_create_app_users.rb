class CreateAppUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :app_users do |t|
    #不能为空
      t.integer :user_id
      t.string :account_name
      t.string :password
      t.string :email, default: ""
      t.string :account_type
      t.string :token
    #额外填写
      t.string :name, default: ""
      t.date :birthday
      t.string :sex, default: ""
    #暂时为空
      t.string :avatar, default: ""
      t.string :education, default: ""
      t.string :school, default: ""
      t.string :language, default: ""
      t.string :profession, default: ""
      t.string :hobby, default: ""
      t.string :signature, default: ""
      t.boolean :is_vip, default: false
      t.date :vip_purchase_date
      t.boolean :activated, default: false
      t.string :activation_token
      t.string :reset_token
      t.datetime :reset_token_generated_time

      t.timestamps
    end
    #涉及到对话查找问题的算法
    add_index :app_users, :user_id, unique: true
    #add_index :app_users, :name, unique: true
    #add_index :app_users, :account_name, unique: true
  end
end
