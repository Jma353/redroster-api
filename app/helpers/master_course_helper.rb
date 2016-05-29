


include CourseReviewsHelper 
module MasterCourseHelper 




	def master_course_with_reviews_json(mc)
		# Serialize the master_course with reviews 
		mc_json_w_reviews = MasterCourseSerializer.new(mc).as_json 
		# Get overall course stats of the master course + merge in 
		review_stats = review_statistics(mc.course_reviews)
		mc_json_w_reviews.merge!({ review_statistics: review_stats })


	end

end 