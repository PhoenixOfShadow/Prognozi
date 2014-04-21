class CreateUserRooms < ActiveRecord::Migration
  def change
    create_table :user_rooms do |t|
      t.integer :room_id
      t.integer :user_id
      t.float :points, default: 0

      t.timestamps
    end
  end
end
