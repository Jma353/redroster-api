# == Schema Information 
# 
#  Table Name: sessions 
#  
#  id 								:integer						not null, primary key 
#  user_id 						:integer 						not null/blank 
#  google_token				:string 						not null/blank 
#  is_active 					:boolean 						true/false 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 


class Session < ActiveRecord::Base

	validates :user_id, presence: true, uniqueness: true 
	validates :google_token, presence: true 
	validate :user_exists, :on => :create 

	before_save :activate_session


	def user_exists 
		errors.add(:user_id, "This user does not exist") unless !User.find_by_id(self.user_id)
	end 



	def activate_session 
		self.is_active = true 
		# For the sake of testing workflows on the bus, going to make the 
		# Google token a base-64 string 
		self.google_token = SecureRandom.urlsafe_base64

	end 

	def character 
		User.find_by_id(self.user_id)
	end 



end
