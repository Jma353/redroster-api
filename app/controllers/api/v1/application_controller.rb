# Generic application controller 


class API::V1::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	# HTTP Request Body includes: 
  # { google_code: ABC,
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


end
