# == Schema Information 
# 
#  Table Name: courses 
#  
#  id					 				:integer					 	not null, PRIMARY KEY 
#  term 							:string 					 	not null/blank, 4 characters 
#  subject 		 				:string 				   	not null/blank, 2 or more characters 
#  number			 				:integer 				   	not null/blank, 1000..9999 range 
#  created_at  				:datetime				   	not null
#  updated_at  				:datetime 				 	not null 

class API::V1::CoursesController < API::V1::ApplicationController
end
