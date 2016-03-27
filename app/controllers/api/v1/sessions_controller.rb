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

require 'net/http' 
require 'json'

class Api::V1::SessionsController < Api::V1::ApplicationController

	def google_auth
		# Get the ID token 
		id_token = params[:id_token]
		# Get the google app id for later validation of the response from Google endpoint 
		google_app_id = ENV["REDROSTER_GOOGLE_APP_ID"] # Use ZSH as local env 

		uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{id_token}")
		res = Net::HTTP.get(uri)
		p res
		if res.is_a?(Net::HTTPSuccess)
			res_json = JSON.parse(res)
			# Render this json to test initial interaction w/iOS app 
			render json: { success: true, key: res_json["sub"] }
		else 
			render json: { success: false, error: "An error occurred.  Please try logging in again." }
		end 

	end 


end
