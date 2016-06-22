# Handles obtaining the user for test or production 
class Api::V1::AuthsController < Api::V1::ApplicationController


	before_action :grab_test_user 
	# before_action :google_auth

end 


