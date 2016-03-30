
module CourseReviewsHelper

	# Given a list of ActiveRecords, compute stats for :lecture, :office_hours, :difficulty, :material... 
	# This is relying on these attr's to be present, which could be bad practice, but
	# I don't expect these values to change 
	def review_statistics(reviews) 
		lecture = 0; office_hours = 0; difficulty = 0; material = 0
		reviews.each do |r| 
			lecture += r.lecture; office_hours += r.office_hours; difficulty += difficulty; material += material 
		end
		total = Float(reviews.size == 0 ? 1 : reviews.size)
		return { lecture: lecture/total, office_hours: office_hours/total, difficulty: difficulty/total, material: material/total }
	end 


end
