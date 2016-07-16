# == Schema Information
#
# Table name: schedule_elements
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  section_id  :integer
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::ScheduleElementsController, type: :controller do

  # Establish a user and schedule 
	before(:each) do
		@u = FactoryGirl.create(:user, google_id: 1)
		@sched = FactoryGirl.create(:schedule, user_id: @u.id, term: "FA15", is_active: true)
	end 

	# Networks Creds 
	networks = { 
		:term => "FA15", 
		:subject => "CS", 
		:number => 2850, 
		:crse_id => 359378,
		:section_num => [12447]
	}

	# Differential Equation Creds
	diff_eq = { 
		:term => "FA15",
		:subject => "MATH",
		:number => 2930,
		:crse_id => 352295,
		:section_num => [6059]
	}

	# Python Creds 
	python_class = {
		:term => "FA15",
		:subject => "CS",
		:number => 1110,
		:section_num => [11829]
	}


	it "Test add course to a schedule" do 

		post :create, common_creds({ id_token: @u.google_id, schedule_element: networks.merge(schedule_id: @sched.id) })
		a = { response: response, print: false, success: true }
		check_response(a)

	end 


	it "Test course conflict recognition" do 

		# Adding Networks 
		post :create, common_creds({ id_token: @u.google_id, schedule_element: networks.merge(schedule_id: @sched.id) })
		a = { response: response, print: false, success: true }
		check_response(a)

		# Adding Diff Eq ( ^ creates a conflict with the above)
		post :create, common_creds({ id_token: @u.google_id, schedule_element: diff_eq.merge(schedule_id: @sched.id) })
		a = { response: response, print: false, success: true }
		check_response(a)

		post :create, common_creds({ id_token: @u.google_id, schedule_element: python_class })
		expect(response).to be_success
		res_json = JSON.parse(response.body)

	end 


	it "Test adding several courses, conflicts only for conflicting ones" do 

		# Adding Networks 
		post :create, common_creds({ id_token: @u.google_id, schedule_element: networks.merge(schedule_id: @sched.id) })
		a = { response: response, print: false, success: true }
		check_response(a)

		# Adding Diff Eq ( ^ creates a conflict with the above)
		post :create, common_creds({ id_token: @u.google_id, schedule_element: diff_eq.merge(schedule_id: @sched.id) })
		a = { response: response, print: false, success: true }
		check_response(a)

		# No conflict for this one 
		post :create, common_creds({ id_token: @u.google_id, schedule_element: python_class.merge(schedule_id: @sched.id) })
		a = { response: response, print: true, success: true }
		check_response(a)

	end 









end






