# == Schema Information
#
# Table name: schedule_elements
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  section_num :integer
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




	it "test add + deletes to FA15 schedule" do 

		# The credentials of FA15 Networks (CS 2850), 11:15 - 12:05
		networks = { 
			:schedule_id => @sched.id, 
			:term => "FA15", 
			:subject => "CS", 
			:course_num => 2850, 
			:section_num => 12447
		}

		post :create, common_creds({ id_token: @u.google_id, schedule_element: networks })
		expect(response).to be_success
		res_json = JSON.parse(response.body)

		# Sanity check 
		pp res_json



		# The credentials of FA15 MATH2930, 11:15 - 12:05 (testing collision detection)
		diff_eq = { 
			:schedule_id => @sched.id, 
			:term => "FA15",
			:subject => "MATH",
			:course_num => 2930,
			:section_num => 6059
		}

		post :create, common_creds({ id_token: @u.google_id, schedule_element: diff_eq })
		expect(response).to be_success
		res_json = JSON.parse(response.body)

		# Santiy check 
		pp res_json

		diff_eq_id = res_json["data"]["schedule_element"]["id"]


		# Now, we expect networks to also have a collision associated with it 
		networks_se = ScheduleElement.find_by(schedule_id: @sched.id, section_num: networks[:section_num])
		expect(networks_se.collision).to eq(true)


		# The credentials of FA15 CS1110, 11:15 - 12:05 (testing collision detection)
		python_class = {
			:schedule_id => @sched.id,
			:term => "FA15",
			:subject => "CS",
			:course_num => 1110,
			:section_num => 11829
		}


		post :create, common_creds({ id_token: @u.google_id, schedule_element: python_class })
		expect(response).to be_success
		res_json = JSON.parse(response.body)

		# Sanity check 
		pp res_json


		delete :destroy, common_creds({ id_token: @u.google_id, schedule_element: { schedule_id: @sched.id, id: diff_eq_id }})
		expect(response).to be_success



		# NOW, since, diff_eq is removed, no longer collision present 
		networks_se = ScheduleElement.find_by(schedule_id: @sched.id, section_num: networks[:section_num])
		expect(networks_se.collision).to eq(false)



	end 








end






