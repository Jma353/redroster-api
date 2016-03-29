class AddMasterCourseIdToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :master_course_id, :integer 
  end
end
