# == Schema Information
#
# Table name: schedule_elements
#
#  schedule_id :integer          not null, primary key
#  section_num :integer          not null
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::ScheduleElementsController, type: :controller do

	# Common credentials 
	def common_creds(extra={})
		{ api_key: ENV["API_KEY"]}.merge(extra)
	end 


  # Establish a user and schedule 
	before(:each) do
		@u = FactoryGirl.create(:user, google_id: 1)
		@sched = FactoryGirl.create(:schedule, user_id: @u.id, term: "FA15")
	end 




	it "test add networks to FA15 schedule" do 

		# The credentials of FA15 Networks (CS 2850)
		schedule_element = { :schedule_id => @sched.id, 
												 :term => "FA15", 
												 :subject => "CS", 
												 :course_num => 2850, 
												 :section_num => 12447
												}

		post :create, common_creds({ id_token: @u.google_id, schedule_element: schedule_element })
		expect(response).to be_success
		res_json = JSON.parse(response.body)

		pp res_json
	end 



	


end
