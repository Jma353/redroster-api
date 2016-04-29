# == Schema Information
#
# Table name: courses
#
#  course_id        :integer          not null, primary key
#  master_course_id :integer
#  term             :string
#  subject          :string
#  number           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Course < ActiveRecord::Base
	# References 
	belongs_to :master_course, class_name: "MasterCourse", foreign_key: "master_course_id"
	has_many :sections, class_name: "Section"

	# Validations 
	validates :course_id, presence: true 
	validates :master_course_id, presence: true 
	validates :term, presence: true, length: { minimum: 4, maximum: 4 }
	validates :subject, presence: true, length: { minimum: 2 }
	validates :number, presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 9999 }
	validate :unique_class, :on => :create 

	def unique_class 
		errors.add_to_base("This course exists already") unless Course.find_by(term: self.term, subject: self.subject, number: self.number).blank?
	end 

	def sections 
		Section.where(course_id: self.id)
	end 

end
