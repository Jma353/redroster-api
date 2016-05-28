class RemoveSubjectFromCourseReviews < ActiveRecord::Migration
  def change
  	remove_column :course_reviews, :subject, :string
  end
end
