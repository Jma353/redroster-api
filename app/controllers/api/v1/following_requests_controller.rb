# == Schema Information
#
# Table name: following_requests
#
#  id          :integer          not null, primary key
#  user1_id    :integer
#  user2_id    :integer
#  sent_by_id  :integer
#  is_pending  :boolean
#  is_accepted :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class Api::V1::FollowingRequestsController < Api::V1::ApplicationController

	# To get the user 
	before_action :grab_test_user 
	# before_action :google_auth


	# Create a following request 
	def create
		# Manually check these each time for now
		user1_id = following_request_params[:user1_id]
		user2_id = following_request_params[:user2_id]

		# Check that the user is actually logged in 
		if (user1_id.to_i != @user.id && user2_id.to_i != @user.id) 
			render json: { success: false, data: { errors: ["You are not logged in as this user."]}} and return false
		end 

		# Reorder as necessary + fill in sent_by_id
		order = [user1_id, user2_id].sort! {|x,y| x <=> y }
		extra = { user1_id: order.first, user2_id: order.second, sent_by_id: @user.id }

		# Make new following_request 
		@fr = FollowingRequest.create(following_request_params(extra))

		# Data + JSON return 
		data = @fr.valid? ? FollowingRequestSerializer.new(@fr).as_json : { errors: @fr.errors.full_messages } 
		render json: { success: @fr.valid?, data: data }
	end 


	# React to a following request 
	def react_to_request 
		# Get the necessary info from the params for this request 
		fr_id = following_request_params[:id] 

		# TODO 
		# Pull user1_id and user2_id from the obtained following_request 
		# Check that the person accepting or rejecting is accepting or rejecting a request sent by another person to THEM 
		# Accept or reject (update the boolean) and make is_pending false 
		# Creating a follower object or update a current one 

		render json: { success: true }

	end 





	private 
		def following_request_params(extra={})
			params[:following_request].present? ? params.require(:following_request).permit(:id, :user1_id, :user2_id).merge(extra) : {} 
		end





end






