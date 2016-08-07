include CoursesHelper 

class AddTitleToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :title, :string

  	# Update any courses
  	Course.all.each do |c|
			c.with_lock do 
				info = get_course_info(c.term, c.subject, c.catalog_number)
				if !info.blank? 
					c.update_attributes!(title: info["titleShort"])
				else 
					c.destroy
				end 
			end 
  	end 

end
