require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do

	it "fetches CS1110 properly" do 

		u = FactoryGirl.create(:user, google_id: "hello_world")

		get 

	end 

end
