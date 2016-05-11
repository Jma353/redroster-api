class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses, { :id => false } do |t|
    	t.integer :course_id 
    	t.references :master_course, index: true
    	t.string :term 
    	t.string :subject 
    	t.integer :number 
        t.integer :credits_maximum
        t.integer :credits_minimum  

    	t.timestamps null: false
    end
    execute "ALTER TABLE courses ADD PRIMARY KEY(course_id);"
  end
end
