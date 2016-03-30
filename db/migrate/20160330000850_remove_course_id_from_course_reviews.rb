class RemoveCourseIdFromCourseReviews < ActiveRecord::Migration
  def change
    remove_column :course_reviews, :course_id, :integer
  end
end
