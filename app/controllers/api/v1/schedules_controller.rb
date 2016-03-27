# == Schema Information 
# 
#  Table Name: schedules
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  user_id 						:integer					 	not null/blank 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class Api::V1::SchedulesController < Api::V1::ApplicationController
end
