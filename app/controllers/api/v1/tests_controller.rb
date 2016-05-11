# Handles obtaining the user for test or production 
class Api::V1::TestsController < Api::V1::ApplicationController


	# before_action :grab_test_user 
	before_action :google_auth

end 