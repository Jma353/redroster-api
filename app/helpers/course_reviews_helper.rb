# == Schema Information
#
# Table name: course_reviews
#
#  id                 :integer          not null, primary key
#  crse_id            :integer
#  user_id            :integer
#  term               :string
#  lecture_score      :integer
#  office_hours_score :integer
#  difficulty_score   :integer
#  material_score     :integer
#  feedback           :string
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
      lecture += r.lecture_score || 0; office_hours += r.office_hours_score || 0; difficulty += r.difficulty_score || 0; material += r.material_score || 0
    end
    total = Float(reviews.size == 0 ? 1 : reviews.size)
    return { lecture_score: lecture/total, office_hours_score: office_hours/total, difficulty_score: difficulty/total, material_score: material/total }
  end


  # Reviews by course JSON (not too much info, but enough)
  def reviews_by_course_json(crse_id, reviews)
    result = {}
    result[:crse_id] = crse_id
    result[:review_statistics] = review_statistics(reviews)
    result[:reviews] = reviews.map { |r| course_review_json(r) }
    return result
  end


  # JSON for the course review we want
  def course_review_json(review)
    CourseReviewSerializer.new(review).as_json
  end


end
