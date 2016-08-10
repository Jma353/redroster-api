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
				email: @google_creds["email"].downcase,
				fname: @google_creds["given_name"].downcase,
				lname: @google_creds["family_name"].downcase,
				picture_url: @google_creds["picture"]
			}
			@user = User.create(user_json)
		end 
		data = user_json(@user).merge({ new_user: @user.blank? })
		render json: { success: @user.valid?, data: data }
	end 


	def people_search
		# Grab query string 
		queries = params[:query].downcase.split("+")
		# Check for equality anywhere  
		people = queries.length < 2 ? User.where("email = ?", queries[0]) : []
		people = people | (queries.length < 2 ? User.where("lname = ?", queries[0]) : 
			User.where("fname = ?", queries[0]).where("lname like ?", "#{queries[1]}%"))
		people = people | (queries.length < 2 ? User.where("fname = ?", queries[0]) : [])
		# Check for matches based on contained strings if none from equality 
		if people.length == 0 
			people = people | (queries.length < 2 ? User.where("email like ?", "#{queries[0]}%") : []) 
			people = people | (queries.length < 2 ? User.where("fname like ?", "#{queries[0]}%") : [])
			people = people | (queries.length < 2 ? User.where("lname like ?", "#{queries[0]}%") : [])
		end 
		# Compose student json + return 
		people = people.map { |p| user_json(p)["user"] }
		render json: { success: true, data: { users: people } } 
	end 


	# For communicating general info 
	def message
		render json: { success: true, data: { message: "" }}
	end 


	private 

		def user_params(extras={})	
			params[:user].present? ? params.require(:user).permit(:id, :google_id) : {} 
		end 


end




