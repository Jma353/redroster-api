# == Schema Information 
# 
#  Table Name: sections 
#  
#  section_num 				:integer					 	not null, PRIMARY KEY 
#  course_id	 				:integer					 	not null/blank 
#  type								:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class API::V1::SectionsController < API::V1::ApplicationController
end
