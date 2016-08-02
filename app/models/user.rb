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

class User < ActiveRecord::Base
	# Associations 
	has_many :course_reviews, class_name: "CourseReview"
	has_many :friendships, class_name: "Friendship"
	has_many :schedules, class_name: "Schedule"
	has_many :followings, class_name: "Following" 
	has_many :following_requests, class_name: "FollowingRequest"


	# Validations 
	validates :google_id, presence: true 
	validate :has_proper_email, :on => :create 

	def has_proper_email
		is_cornell_email = self.email.match(/\A[\w+\-.]+@cornell.edu/) 
		is_apple_reviewer = (self.email == "redrostertester@gmail.com")
		if !(is_cornell_email || is_apple_reviewer) 
			errors[:base] << ("This app requires a Cornell email to login")
		end 
	end 

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


	# To access follows (relationships where the THIS user is followed by someone else)
	def followers	
		u_is_u1 = Following.where(user1_id: self.id, u2_follows_u1: true)
		u_is_u2 = Following.where(user2_id: self.id, u1_follows_u2: true)
		u_is_u1 + u_is_u2
	end 


	# People THIS user follows 
	def followees 	
		u_is_not_u1 = Following.where('u1_follows_u2 = ? AND user1_id = ?', true, self.id)
		u_is_not_u2 = Following.where('u2_follows_u1 = ? AND user2_id = ?', true, self.id)
		u_is_not_u1 + u_is_not_u2 
	end 


	# Relationships this user is involved in 
	def followings 
		followings = Following.where('user1_id = ? OR user2_id = ?', self.id, self.id)
	end 


end




