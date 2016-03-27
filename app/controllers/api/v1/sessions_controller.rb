# == Schema Information 
# 
#  Table Name: sessions 
#  
#  id 								:integer						not null, primary key 
#  user_id 						:integer 						not null/blank 
#  google_token				:string 						not null/blank 
#  is_active 					:boolean 						true/false 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class API::V1::SessionsController < API::V1::ApplicationController

	def google_id
		# Get the ID token 
		id_token = params[:id_token]
		# Get the google app id for later validation of the response from Google endpoint 
		google_app_id = ENV["GOOGLE_APP_ID"]
		# Render this json to test initial interaction w/iOS app 
		render json: { success: true }
	end 

	

end
