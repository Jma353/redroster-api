# == Schema Information 
# 
#  Table Name: sections 
#  
#  section_num 				:integer					 	not null, PRIMARY KEY 
#  course_id	 				:integer					 	not null/blank 
#  type								:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class Api::V1::SectionsController < Api::V1::ApplicationController
end
