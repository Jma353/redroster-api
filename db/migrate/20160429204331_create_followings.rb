class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
    	t.references :user1, index: true 
    	t.references :user2, index: true 
			t.boolean :is_active 	
			t.integer :following_score 

      t.timestamps null: false
    end
  end
end
