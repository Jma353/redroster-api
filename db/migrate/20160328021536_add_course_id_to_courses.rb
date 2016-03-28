class AddCourseIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_id, :integer
  end
end
