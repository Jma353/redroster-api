include CoursesHelper 

class AddTitleToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :title, :string
  		
  	
  	Course.all.each do |c|
  		info = get_course_info(c.term, c.subject, c.catalog_number)
  		c.update_attributes!(title: info["titleShort"])
  	end 


  end
end
