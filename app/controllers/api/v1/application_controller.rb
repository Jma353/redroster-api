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
      render json: { success: false, error: "Unauthorized services cannot use this backend"}, status: :unauthorized
      return false 
    end 
  end 


  # Maintains google auth state 
  def google_auth
    # Get the ID token 
    id_token = params[:id_token]
    # Get the google app id for later validation of the response from Google endpoint 
    google_app_id = ENV["REDROSTER_GOOGLE_APP_ID"] # Use ZSH as local env 
    # To obtain proper sub-idToken from google for account access 
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{id_token}")

    res = Net::HTTP.get(uri)
    res_json = JSON.parse(res)
    p res_json
    render json: { success: false, error: "An error occurred.  Please try logging in again." } unless 
                          (res_json["error_description"].blank? && res_json["aud"].include?(google_app_id))

    # Pass this along to see what's going on w/the User 
    google_id = res_json["sud"]
    @user = User.find_by_google_id(google_id)
  end 



  # BUILT FOR THE PURPOSES OF TESTING ENDPOINTS FOR SCHEDULE CREATION AND SUCH 
  def grab_test_user 
    google_id = params[:id_token]
    @user = User.find_by_google_id(google_id)
  end 



  # Check to see if the schedule exists/belongs to the user  (used in specific subclasses)
  def schedule_belongs_to_user
    @schedule = Schedule.where(user_id: @user.id).find_by_id(params[:schedule_id])
    if @schedule.blank? 
      render json: { success: false, data: { errors: "This schedule either doesn't exist or doesn't belong to you" } }
    else 
      @schedule
    end 
  end 
  

end
