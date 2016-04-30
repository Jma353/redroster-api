# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Schedule < ActiveRecord::Base
	# References 
	belongs_to :user, class_name: "User", foreign_key: "user_id"
	has_many :schedule_elements, class_name: "ScheduleElement", dependent: :destroy

	# Validations 
	validates :user_id, presence: true 
	validates :term, presence: true 
	validate :user_exists, :on => :create 
	



	def user_exists 
		errors.add_to_base("This user does not exist") unless !User.find_by_id(self.user_id).blank? 
	end 





end
