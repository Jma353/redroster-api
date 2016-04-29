class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
    	t.references :user1, index: true 
    	t.references :user2, index: true
    	t.boolean :is_active

    	t.timestamps null: false
    end
  end
end
