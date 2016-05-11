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


class Api::V1::FollowingRequestsController < Api::V1::TestsController 


	# Create a following request 
	def create
		# Grab the user_id of the user being sent this following request 
		user_id = following_request_params[:user_id].to_i

		# Reorder as necessary + fill in sent_by_id
		order = [user_id, @user.id].sort! {|x,y| x <=> y }
		extra = { user1_id: order.first, user2_id: order.second, sent_by_id: @user.id }

		# Make new following_request 
		@fr = FollowingRequest.create(extra)

		# Data + JSON return 
		data = @fr.valid? ? FollowingRequestSerializer.new(@fr).as_json : { errors: @fr.errors.full_messages } 
		render json: { success: @fr.valid?, data: data }
	end 





	# React to a following request 
	def react_to_request 
		# Get the necessary info from the params for this request 
		fr_id = following_request_params[:id] 
		accept = params[:accept]

		# Pull following_request or render error
		@fr = FollowingRequest.find_by_id(fr_id)
		if @fr.blank? || @fr.is_pending == false
			render json: { success: false, data: { errors: "No active following request exists with this id" } } and return false 
		end 	

		# Check if this user is valid to respond to this request 
		valid_user = @fr.valid_reacting_user(@user)
		if !valid_user 
			render json: { success: false, data: { errors: "You don't have permission to accept or reject this following request" } } and return false
		end 	

		# Update the friend request 
		@fr.update_attributes(is_pending: false, is_accepted: accept)

		# If accepted friend request
		if accept	
			# Update or create model w/appropriate information
			data = (@user.id == @fr.user1_id) ? { u2_follows_u1: true } : { u1_follows_u2: true }
			@following = Following.find_or_create_by(user1_id: @fr.user1_id, user2_id: @fr.user2_id)
			@following.update_attributes(data)
		end 	

		# Return the reaction and possible following object 
		render json: { success: true, data: { following_request_accepted: accept, following: @following } }

	end 






	private 
		def following_request_params(extra={})
			params[:following_request].present? ? params.require(:following_request).permit(:id, :user_id).merge(extra) : {} 
		end



end






