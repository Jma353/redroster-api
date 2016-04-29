# == Schema Information 
# 
#  Table Name: users
#  
#  id     		 				:integer 				 	 	not null, PRIMARY KEY 	
#  google_id 					:integer						not null, corresponds w/Google SUD # returned on validation w/Google sign-in 		 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 			 	 	not null 

class User < ActiveRecord::Base
	# Associations 
	has_many :course_reviews, class_name: "CourseReview"
	has_many :friendships, class_name: "Friendship"
	has_many :schedules, class_name: "Schedule"


	validates :google_id, presence: true 

	
	def friends
		a = Friendship.where(user1_id: self.id)
		b = Friendship.where(user2_id: self.id)
		a = a.map { |f| f.user2 }
		b = b.map { |f| f.user1 }
		a + b
	end 

	# Required number of reviews is 5 to see reviews on the platform 
	def has_completed_reviews
		reviews = CourseReview.where(user_id: self.id)
		reviews.size >= 5
	end 

end
