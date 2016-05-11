class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :google_id
    	t.string :email
    	t.string :fname 
    	t.string :lname
    	t.string :picture_url
    	

    	t.timestamps null: false
    end
  end
end
