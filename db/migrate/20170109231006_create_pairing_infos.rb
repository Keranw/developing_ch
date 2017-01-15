class CreatePairingInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :pairing_infos do |t|
      t.integer :app_user_id
      t.integer :user_id
      t.integer :postcode
      t.float :longitude
      t.float :latitude
      t.string :rest_five, default: [], array:true
      #颜值积分
      t.integer :like, default: 0
      t.integer :dislike, default: 0
      #谁喜欢我
      t.integer :like_list, default: [], array:true
      #谁见过我
      t.integer :met_me, default: [], array:true
      t.timestamps
    end
  end
end
