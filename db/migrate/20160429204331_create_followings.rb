class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :user1, index: true
      t.references :user2, index: true
      t.boolean :u1_follows_u2
      t.boolean :u2_follows_u1
      t.integer :u1_popularity
      t.integer :u2_popularity
      t.boolean :is_active


      t.timestamps null: false
    end
  end
end
