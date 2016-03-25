# == Schema Information 
# 
#  Table Name: schedule_elements
# 
#  PRIMARY KEY: (schedule_id, section_id)
# 
#  schedule_id 				:integer 						not null
#  section_id 				:integer						not null
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class ScheduleElement < ActiveRecord::Base

	# Must be validated b/c they make up the primary key 
	validates :schedule_id, presence: true
	validates :section_id, presence: true 

end
