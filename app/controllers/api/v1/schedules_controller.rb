# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

include SchedulesHelper
class Api::V1::SchedulesController < Api::V1::ApplicationController

	# To get a test user to associate this schedule with 
	before_action :grab_test_user 
	# before_action :google_auth 

	before_action :schedule_belongs_to_user, only: [:show, :clear, :destroy] # in ApplicationController 


  # Check to see if the schedule exists/belongs to the user  (used in specific subclasses)
  def schedule_belongs_to_user
  	@schedule = @user.schedules.find_by_id(params[:id])
    if @schedule.blank? 
      render json: { success: false, data: { errors: ["This schedule either doesn't exist or doesn't belong to you"] } }
    else 
      @schedule
    end 
  end 



	# Schedule creation endpoint 
	def create
		@s = @user.schedules.create(schedule_params)
		data = @s.errors.any? ? { errors: @s.errors.full_messages } : schedule_json(@s)
		render json: { success: @s.valid?, data: data } 
	end 


	def index 
		render json: { success: true, data: user_schedules(@user) }
	end 


	# Schedule + all sections that are in it 
	def show 
		render json: { success: true, data: schedule_json(@schedule) } 
	end 


	# Clear the schedule of all schedule_elements 
	def clear 
		@schedule_elements = ScheduleElements.where(schedule_id: @schedule.id)
		@schedule_elements.each do |se|
			se.destroy 
		end 
		render json: { success: true }
	end 


	# Schedule deletion endpoint 
	def destroy
		# Also deletes all corresponding ScheduleElements b/c of `:dependent => :destroy` in the model 
		@schedule.destroy
		render json: { success: !@schedule.blank? }
	end 




	private 

		def schedule_params(extras={})	
			params[:schedule].present? ? params.require(:schedule).permit(:term, :name).merge(extras) : {} 
		end 




end





