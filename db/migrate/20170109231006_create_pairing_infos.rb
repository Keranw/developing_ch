class CreatePairingInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :pairing_infos do |t|
      t.integer :app_user_id
      t.integer :user_id
      t.integer :postcode
      t.float :longitude
      t.float :latitude
      t.integer :met_me, default: [], array:true
      t.integer :like, default: 0
      t.integer :dislike, default: 0
      t.integer :like_list, default: [], array:true

      t.timestamps
    end
  end
end