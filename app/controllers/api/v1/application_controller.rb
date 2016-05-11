# Generic application controller 

class Api::V1::ApplicationController < ActionController::Base
  # So this/every subclass has these two modules 
  require 'net/http'
  require 'json'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token # Add own custom API key for iOS frontend 
  before_action :check_api_key 


	# HTTP Request Body includes: 
  # { api_key: API_KEY,
  #   id_token: ABC,
  #   // Everything else 
  # }


  # Checks the request to see if it's coming from the proper frontend 
  def check_api_key 
    head(401) and return false if params[:api_key].blank? 
    provided_api_key = params[:api_key]
    if provided_api_key != ENV["API_KEY"]
      render json: { success: false, data: { errors: ["Unauthorized services cannot use this backend"] } }, status: :unauthorized
      return false 
    end 
  end 


  # Grabs google_id
  def google_creds 
    # Get the ID token 
    id_token = params[:id_token]
    # Get the google app id for later validation of the response from Google endpoint 
    google_app_id = ENV["REDROSTER_GOOGLE_APP_ID"] # Use ZSH as local env 
    # To obtain proper sub-idToken from google for account access 
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{id_token}")

    res = Net::HTTP.get(uri)
    res_json = JSON.parse(res)
    p res_json
    if !(res_json["error_description"].blank? && res_json["aud"].include?(google_app_id))
      render json: { success: false, data: { errors: ["An error occurred.  Please try logging in again."] } } and return false
    else                  
      # Pass this along to see what's going on w/the User 
      @google_creds = res_json
    end 
  end 


  # Checks to see if a user actually exists with verified google_id 
  def google_auth 
    google_id = google_creds["sub"]
    if google_id == false 
      return 
    end 
    @user = User.find_by_google_id(google_id)
    if @user.blank? 
      render json: { success: false, data: { errors: ["No user exists with these Google credentials.  Please sign in as a new user."] } }
    else 
      @user
    end 
  end 





  # BUILT FOR THE PURPOSES OF TESTING ENDPOINTS FOR SCHEDULE CREATION AND SUCH 
  def grab_test_user 
    google_id = params[:id_token]
    @user = User.find_by_google_id(google_id)
  end 








end
