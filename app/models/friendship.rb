# == Schema Information 
# 
#  Table Name: friendships
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  user1_id 					:integer					 	not null/blank 
#  user2_id						:integer						not null/blank
#  is_active 					:boolean 						true/false
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 



class Friendship < ActiveRecord::Base

	belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  validates :user1_id, presence: true
  validates :user2_id, presence: true
  validate :user1_is_not_user2
  

 	def user1_is_not_user2 
 		errors.add_to_base("You can't friend request yourself") unless self.user1_id != self.user2_id
 	end 

 	
end
