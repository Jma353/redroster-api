class AddSubjectToCourseReviews < ActiveRecord::Migration
  def change
  	add_column :course_reviews, :subject, :string 
  end
end
