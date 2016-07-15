# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  google_id   :string
#  email       :string
#  fname       :string
#  lname       :string
#  picture_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

include UsersHelper
class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :google_creds, only: [:google_sign_in]
	
	# Google sign in and user creation on new user sign in 
	def google_sign_in 	
		@google_id = @google_creds["sub"]
		# @user passed by google_auth() method if the method succeeds 
		@user = User.find_by_google_id(@google_id)
		if @user.blank? 
			user_json = { 
				google_id: @google_id, 
				email: @google_creds["email"],
				fname: @google_creds["given_name"],
				lname: @google_creds["family_name"],
				picture_url: @google_creds["picture"]
			}
			@user = User.create(user_json)
		end 
		data = user_json(@user).merge({ new_user: @user.blank? })
		render json: { success: @user.valid?, data: data }
	end 





	# Creation method for testing purposes, w/o Google sign in 
	def create 
		@user = User.create(user_params)
		data = @user.valid? ? user_json(@user) : { errors:  @user.errors.full_messages } 
		render json: { success: @user.valid?, data: data }
	end 





	private 

		def user_params(extras={})	
			params[:user].present? ? params.require(:user).permit(:id, :google_id) : {} 
		end 


end
