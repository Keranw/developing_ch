class CreateMessageTemps < ActiveRecord::Migration[5.0]
  def change
    create_table :message_temps do |t|
      t.integer :from_id
      t.integer :to_id
      t.integer :msg_type
      t.string :content
      t.integer :time_interval
      t.text :image_temp

      t.timestamps
    end
  end
end
