class AddFeedbackToCourseReviews < ActiveRecord::Migration
  def change
  	add_column :course_reviews, :feedback, :string
  end
end
