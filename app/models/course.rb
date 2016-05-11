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
	has_many :schedule_elements, through: :sections


	has_many :schedule_elements, through: :sections, foreign_key: "section_num"
	has_many :schedules, through: :schedule_elements


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



	# All the users with active schedules that include this class 
	# Made the decision to write this method rather than using the :through associations 
	# b/c :through uses INNER JOIN, rather than indexing (or so it seems)
	def users 
		users_set = [] 
		self.sections.each do |s|
			s.schedule_elements.each do |se|
				users_set = users_set | [se.schedule.user] # append the user
			end 
		end
		users_set 
	end




end










