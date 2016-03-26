# == Schema Information 
# 
#  Table Name: schedules
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  user_id 						:integer					 	not null/blank 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 



class API::V1::SchedulesController < API::V1::ApplicationController
end
