# Generic application controller 

class Api::V1::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token # Add own custom API key for iOS frontend 
  before_action :check_api_key 


	# HTTP Request Body includes: 
  # { api_key: API_KEY,
  #   google_code: ABC,
  #   // Everything else 
  # }


  # Authorization based upon Google code; this function isn't 
  # validating the Google code, but rather ensuring that a Session has been created 
  # on THIS backend storing a Google code corresponding to a User 
  def authorize
    head(401) and return false if params[:google_code].blank?
    @session = Session.find_by_session_code(params[:google_code])
    if @session.blank?
      render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
      return false
    end
    @user = @session.character
  end

  # Checks the request to see if it's coming from the proper frontend 
  def check_api_key 
    head(401) and return false if params[:api_key].blank? 
    provided_api_key = params[:api_key]
    if provided_api_key != ENV["API_KEY"]
      render json: { success: false, error: "Unauthorized services cannot use this backend"}, status: :unauthorized
      return false 
    end 
  end 


end
