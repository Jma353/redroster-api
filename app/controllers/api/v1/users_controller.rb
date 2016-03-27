# == Schema Information 
# 
#  Table Name: users
#  
#  id     		 				:integer 				 	 	not null, PRIMARY KEY 	
#  google_id 					:integer						not null, corresponds w/Google SUD # returned on validation w/Google sign-in 		 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 			 	 	not null 

class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :google_auth

	def google_sign_in 	
		@user = User.find_by_google_id(@google_id)
		if @user.blank? 
			User.create(google_id: @google_id)
		end 
		render json: { "new_user" => !@user.blank? }
	end 


end
