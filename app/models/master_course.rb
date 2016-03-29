# == Schema Information 
# 
#  Table Name: master_courses 
#  
#  id									:integer					 	not null, primary key 
#  subject 		 				:string 				   	not null/blank, 2 or more characters 
#  number			 				:integer 				   	not null/blank, 1000..9999 range 
#  created_at  				:datetime				   	not null
#  updated_at  				:datetime 				 	not null 

# To track all courses + reviews ever, just just given a term 

class MasterCourse < ActiveRecord::Base
end
