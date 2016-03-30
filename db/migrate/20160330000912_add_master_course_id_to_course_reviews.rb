class AddMasterCourseIdToCourseReviews < ActiveRecord::Migration
  def change
    add_column :course_reviews, :master_course_id, :integer
  end
end
