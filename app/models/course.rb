# == Schema Information
#
# Table name: courses
#
#  id                  :integer          not null, primary key
#  crse_id             :integer
#  term                :string
#  subject             :string
#  catalog_number      :integer
#  course_offer_number :integer
#  credits_maximum     :integer
#  credits_minimum     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Course < ActiveRecord::Base
	# References 
	belongs_to :master_course, class_name: "MasterCourse", foreign_key: "master_course_id"
	has_many :sections, class_name: "Section", :dependent => :destroy
	has_many :schedule_elements, through: :sections

	has_many :schedule_elements, through: :sections, foreign_key: "section_num"
	has_many :schedules, through: :schedule_elements


	# Validations 
	validates :crse_id, presence: true, uniqueness: { scope: [:term] }
	validates :term, presence: true, length: { minimum: 4, maximum: 4 }
	validate :unique_class, :on => :create 


	def unique_class 
		errors[:base] << ("This course exists already") unless Course.find_by(term: self.term, crse_id: self.crse_id).blank?
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
				if se.schedule.is_active
					users_set = users_set | [se.schedule.user] # append the user
				end 
			end 
		end
		users_set 
	end



end










