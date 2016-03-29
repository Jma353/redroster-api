class AddUserIdToCourseReviews < ActiveRecord::Migration
  def change
    add_column :course_reviews, :user_id, :integer
  end
end
