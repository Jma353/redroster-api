class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user1_id
      t.integer :user2_id
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
