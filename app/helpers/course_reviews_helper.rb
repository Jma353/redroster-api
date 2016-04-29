# == Schema Information
#
# Table name: course_reviews
#
#  id                 :integer          not null, primary key
#  master_course_id   :integer
#  user_id            :integer
#  term               :string
#  lecture_score      :integer
#  office_hours_score :integer
#  difficulty_score   :integer
#  material_score     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#


module CourseReviewsHelper

	# Given a list of ActiveRecords, compute stats for :lecture, :office_hours, :difficulty, :material... 
	# This is relying on these attr's to be present, which could be bad practice, but
	# I don't expect these values to change 
	def review_statistics(reviews) 
		lecture = 0; office_hours = 0; difficulty = 0; material = 0
		reviews.each do |r| 
			lecture += r.lecture; office_hours += r.office_hours; difficulty += r.difficulty; material += r.material 
		end
		total = Float(reviews.size == 0 ? 1 : reviews.size)
		return { lecture: lecture/total, office_hours: office_hours/total, difficulty: difficulty/total, material: material/total }
	end 

	def instructor_name(json) 
		"#{json['firstName']} #{json['lastName']}"
	end

	def get_prof(term, subject, number)
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&q=#{number}")
		result_json = JSON.parse(Net::HTTP.get(uri))
		instructors = result_json["data"]["classes"][0]["enrollGroups"][0]["classSections"][0]["meetings"][0]["instructors"]
		result = ""
		instructors.each do |i|
			result += instructor_name(i)
			if i != instructors.last 
				result += " & "
			end
		end 
		result 
	end 

end
