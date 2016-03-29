# == Schema Information 
# 
#  Table Name: sections 
#  
#  section_num 				:integer					 	not null, PRIMARY KEY 
#  course_id	 				:integer					 	not null/blank 
#  section_type				:string 						not null/blank
#  start_time 				:string							not null/blank
#  end_time						:string 						not null/blank
#  day_pattern 				:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 


class Api::V1::SectionsController < Api::V1::ApplicationController
end
