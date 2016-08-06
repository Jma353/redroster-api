class AddCourseInfoToScheduleElements < ActiveRecord::Migration
  def change
  	add_column :schedule_elements, :subject, :string
  	add_column :schedule_elements, :catalog_number, :integer

  	# Update all current schedule_elements accordingly 
  	ScheduleElement.all.each do |se|
  		se_course = se.section.course
  		se.update_attributes!(:subject => se_course.subject, :catalog_number => se_course.catalog_number)
  	end 

  end
end
