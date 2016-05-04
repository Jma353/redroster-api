# == Schema Information
#
# Table name: master_courses
#
#  id         :integer          not null, primary key
#  subject    :string
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# To track all courses + reviews ever, just given a term 

include CourseReviewsHelper
class MasterCourse < ActiveRecord::Base
	# References 
	has_many :courses, class_name: "Course"
	has_many :course_reviews, class_name: "CourseReview"
	
	
	
	# Validations 
	validates :subject, presence: true 
	validates :number, presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 9999 }



	

end
