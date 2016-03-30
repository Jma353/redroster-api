class AddFieldsToCourseReviews < ActiveRecord::Migration
  def change
    add_column :course_reviews, :term, :string
    add_column :course_reviews, :lecture, :integer
    add_column :course_reviews, :office_hours, :integer
    add_column :course_reviews, :difficulty, :integer
    add_column :course_reviews, :material, :integer
  end
end
