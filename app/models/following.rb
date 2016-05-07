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


# NOTE: Made the model this bloated to save DB rows 
class Following < ActiveRecord::Base
	
	# References 
	belongs_to :user1, class_name: "User", foreign_key: "user1_id"
	belongs_to :user2, class_name: "User", foreign_key: "user2_id"
	

	# Validations (note, :scope checks one param against 1+ other params)
	validates :user1_id, presence: true, uniqueness: { scope: :user2_id } 
	validates :user2_id, presence: true, numericality: { greater_than: :user1_id }


	# Defaults + value setting 
	before_create :default_values 


	# Default values 
	def default_values 
		self.u1_popularity = 0
		self.u2_popularity = 0 
		self.is_active = true 
	end 
	

	# rel is either u1_follows_u2, or u2_follows_u1, associated with a boolean 
	def change_follow_status(rel={})
		self.update_attributes(rel)
		return false unless valid? 
		save! 
	end 		




end
