class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
    	t.integer :crse_id
    	t.string :term 
    	t.string :subject 
    	t.integer :catalog_number
        t.integer :course_offer_number
    	t.integer :credits_maximum
    	t.integer :credits_minimum  

    	t.timestamps null: false
    end
  end
end
