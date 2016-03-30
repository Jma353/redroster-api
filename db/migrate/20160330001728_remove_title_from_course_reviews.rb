class RemoveTitleFromCourseReviews < ActiveRecord::Migration
  def change
    remove_column :course_reviews, :title, :string
  end
end
