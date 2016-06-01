# == Schema Information
#
# Table name: followings
#
#  id            :integer          not null, primary key
#  user1_id      :integer
#  user2_id      :integer
#  u1_follows_u2 :boolean
#  u2_follows_u1 :boolean
#  u1_popularity :integer
#  u2_popularity :integer
#  is_active     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


class Api::V1::FollowingsController < Api::V1::AuthsController

	# Endpoint to fetch all followers of the logged-in user 
	def fetch_followers
		followers_json = @user.followers.map do |f|
			FollowingSerializer.new(f).as_json
		end 
		render json: { success: true, data: { followers: followers_json }}
	end 


	# Endpoint to fetch all followers of the logged-in user
	def fetch_followees
		followees_json = @user.followees.map do |f|
			FollowingSerializer.new(f).as_json 
		end 
		render json: { success: true, data: { followees: followees_json }}
	end


	# Endpoint to fetch all followings (relationships that the logged-in user is involved in) 
	def fetch_followings 
		followings_json = @user.followings.map do |f|
			FollowingSerializer.new(f).as_json
		end 
		render json: { success: true, data: { followings: followings_json }}
	end 




end





