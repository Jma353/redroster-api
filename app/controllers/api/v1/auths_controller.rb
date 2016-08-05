# Handles obtaining the user for test or production 
class Api::V1::AuthsController < Api::V1::ApplicationController


	before_action :grab_user_by_env


	def grab_user_by_env
		if (Rails.env == 'production' || Rails.env == 'development'  || Rails.env == 'staging')
			return google_auth
		else
			return grab_test_user
		end 
	end 


end 


