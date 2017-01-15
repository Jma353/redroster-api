class CreateFollowingRequests < ActiveRecord::Migration
  def change
    create_table :following_requests do |t|
      t.references :user1, index: true
      t.references :user2, index: true
      t.references :sent_by, index: true
      t.boolean :is_pending
      t.boolean :is_accepted


      t.timestamps null: false
    end
  end
end
