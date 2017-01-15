class CreateCourseReviews < ActiveRecord::Migration
  def change
    create_table :course_reviews do |t|
      t.integer :crse_id
      t.references :user, index: true
      t.string :term
      t.integer :lecture_score
      t.integer :office_hours_score
      t.integer :difficulty_score
      t.integer :material_score
      t.string :feedback

      t.timestamps null: false
    end
  end
end
