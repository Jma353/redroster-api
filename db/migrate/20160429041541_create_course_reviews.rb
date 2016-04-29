class CreateCourseReviews < ActiveRecord::Migration
  def change
    create_table :course_reviews do |t|
    	t.references :master_course, index: true
    	t.references :user, index: true 
    	t.string :term 
    	t.integer :lecture_score
    	t.integer :office_hours_score
    	t.integer :difficulty_score
    	t.integer :material_score

    	t.timestamps null: false
    end
  end
end
