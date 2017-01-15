# == Schema Information
#
# Table name: following_requests
#
#  id          :integer          not null, primary key
#  user1_id    :integer
#  user2_id    :integer
#  sent_by_id  :integer
#  is_pending  :boolean
#  is_accepted :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::FollowingRequestsController, type: :controller do



  # Check the JSON response of each endpoint
  def check_json_response(response, success=true, print=true)
    expect(response).to be_success
    json_res = JSON.parse(response.body)
    if print
      pp json_res
    end
    expect(json_res["success"]).to eq(success)
    json_res
  end


  # Before each test
  before(:each) do
    @u1 = FactoryGirl.create(:user, google_id: 123)
    @u2 = FactoryGirl.create(:user, google_id: 124)
  end



  # Create a following_request
  def create_following_request(s, r)
    post :create,
    common_creds({ id_token: s.google_id,
      following_request: { user_id: r.id }})
  end



  # Sending following request from user1 to user2
  it "Create successful following request" do
    create_following_request(@u1, @u2)
    json_res = check_json_response(response)
  end



  # Send following request from user1 to user2 and fail
  it "Try to friend myself" do
    create_following_request(@u1, @u1)
    json_res = check_json_response(response, false)
  end



  it "Following request followed by acceptance" do
    # user1 wants to follow user2
    create_following_request(@u1, @u2)

    # Check the JSON response without printing
    json_res = check_json_response(response, true, false)

    # Grab the integer of this following request (would be present on frontend)
    follow_req_id = json_res["data"]["following_request"]["id"].to_i

    # user2 accepts this request
    post :react_to_request,
    common_creds({ id_token: @u2.google_id, accept: true,
      following_request: { id: follow_req_id }})
    json_res = check_json_response(response, true, true)


  end



  it "Following request followed by acceptance, then vice versa" do
    ### USER 2 REQUESTING AND FOLLOWING USER 1 ###


    # user2 wants to follow user1
    create_following_request(@u2, @u1)
    json_res = check_json_response(response, true, false)

    # Grab the integer of this following request
    follow_req_id = json_res["data"]["following_request"]["id"].to_i

    # user1 accepts user2's request
    post :react_to_request,
    common_creds({ id_token: @u1.google_id, accept: true,
      following_request: { id: follow_req_id }})
    json_res = check_json_response(response, true, true)


    ### USER 1 REQUESTING AND FOLLOWING USER 2 ###


    # user1 wants to follow user2
    create_following_request(@u1, @u2)
    json_res = check_json_response(response, true, false)

    # Grab the integer of this following request
    follow_req_id = json_res["data"]["following_request"]["id"].to_i

    # user2 accepts user1's request
    post :react_to_request,
    common_creds({ id_token: @u2.google_id, accept: true,
      following_request: { id: follow_req_id }})
    json_res = check_json_response(response, true, true)




  end








end
