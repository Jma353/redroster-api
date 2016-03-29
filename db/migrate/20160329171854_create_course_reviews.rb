class CreateCourseReviews < ActiveRecord::Migration
  def change
    create_table :course_reviews do |t|
      t.integer :course_id
      t.string :title
      t.text :feedback

      t.timestamps null: false
    end
  end
end
