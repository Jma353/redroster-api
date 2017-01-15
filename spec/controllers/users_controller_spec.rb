# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  google_id   :string
#  email       :string
#  fname       :string
#  lname       :string
#  picture_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  before(:each) do
    @u = FactoryGirl.create(:user, google_id: "hello_world")
  end

  it "people search test" do

    # Create some users
    (1..100).each do |n|
      FactoryGirl.create(:user, fname: "user#{n}", lname: "name#{n % 10}", google_id: n, email: "user#{n}@cornell.edu")
    end

    get :people_search, common_creds({ id_token: @u.google_id, query: "user2+n" })
    a = { response: response, print: true, success: true }
    check_response(a)

  end

end
