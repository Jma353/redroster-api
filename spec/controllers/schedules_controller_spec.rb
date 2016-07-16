# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  name       :string
#  is_active  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::SchedulesController, type: :controller do

	# Establish user 
	before(:each) do
		@u = FactoryGirl.create(:user, google_id: 1)	
	end 	

	# Create schedule 
	def create_schedule(u, term, name, is_active)
		post :create, common_creds({ id_token: u.google_id,
			schedule: { term: term, name: name, is_active: is_active }})
	end 

	def schedules_index(u)
		get :index, common_creds({ id_token: u.google_id })
	end 


	it "Allows successful schedule creation" do 

		create_schedule(@u, "FA15", "Hello world", true)
		a = { response: response, print: true, success: true }
		check_response(a)

	end 


	it "Allows successful schedule creation with changes in is_active" do 

		create_schedule(@u, "FA15", "Hello world", true)
		a = { response: response, print: false, success: true }
		check_response(a)

		create_schedule(@u, "FA15", "Hello World 2", true)
		a[:response] = response
		check_response(a)

		schedules_index(@u)
		a.merge!({ response: response, print: true })
		check_response(a)

	end 


	it "Disallows for creation of schedules with the same name" do 

		common_name = "hello world"

		create_schedule(@u, "FA15", common_name, true)
		a = { response: response, print: false, success: true }
		check_response(a)

		create_schedule(@u, "FA15", common_name, true)
		a = { response: response, print: true, success: false }
		check_response(a)

	end 





end










