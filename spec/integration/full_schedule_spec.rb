# spec/integration/full_schedule_spec.rb 
# Integration spec written to test full schedule creation + integrated validations

require 'rails_helper'


describe "Full Schedule Creation", :type => :request do

  before(:each) do
    @u = FactoryGirl.create(:user, google_id: 1, fname: "Joe", lname: "Antonakakis")
    @u2 = FactoryGirl.create(:user, google_id: 2, fname:  "Daniel", lname: "Li")
    @u3 = FactoryGirl.create(:user, google_id: 3, fname: "Emily", lname: "Smith")
  end

  def create_schedule(u, term, name, is_active)
    post "/api/v1/schedules/create", common_creds({ id_token: u.google_id, schedule: { term: term, name: name, is_active: is_active }})
  end

  def show_schedule(u, schedule_id)
    get "/api/v1/schedules/show/#{schedule_id}", common_creds({ id_token: u.google_id })
  end

  def add_section_to_schedule(u, s)
    post "/api/v1/schedule_elements/create", common_creds({ id_token: u.google_id, schedule_element: s })
  end

  def remove_section_from_schedule(u, schedule_id, se_id)
    delete "/api/v1/schedule_elements/delete", common_creds({ id_token: u.google_id, schedule_element: { schedule_id: schedule_id, id: [se_id] }})
  end

  def destroy_schedule(u, schedule_id)
    delete "/api/v1/schedules/delete/#{schedule_id}", common_creds({ id_token: u.google_id })
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
    :crse_id => 358526,
    :section_num => [11829]
  }

  # Checks general schedule creation
  it "schedule creation + adding valid sections to the schedule" do

    create_schedule(@u, "FA15", "my sched", true)
    a = { response: response, print: false, success: true }
    json_res = check_response(a)

    # Grab id for reference
    schedule_id = json_res["data"]["schedule"]["id"]

    pp "Created schedule"
    show_schedule(@u, schedule_id)
    a = { response: response, print: true, success: true }
    json_res = check_response(a)

    pp "Add networks"
    add_section_to_schedule(@u, networks.merge({ schedule_id: schedule_id }))
    a = { response: response, print: true, success: true }
    json_res = check_response(a)

    pp "Add diff eq"
    add_section_to_schedule(@u, diff_eq.merge({ schedule_id: schedule_id }))
    a = { response: response, print: true, success: true }
    json_res = check_response(a)

    # Grab id for reference
    diff_eq_id = json_res["data"]["schedule"]["courses"][1]["schedule_elements"][0]["schedule_element"]["id"]

    pp "Remove diff eq"
    remove_section_from_schedule(@u, schedule_id, diff_eq_id)
    a = { response: response, print: true, success: true }
    json_res = check_response(a)

    pp "Delete schedule"
    destroy_schedule(@u, schedule_id)
    a = { response: response, print: true, success: true }
    json_res = check_response(a)

    # Make sure this is true
    se = ScheduleElement.where(schedule_id: schedule_id)
    expect(se.length).to eq(0)

  end

  # Checks schedule creation and listing of people in courses
  it  "Schedule creation + calling course endpoints to see users in them" do

    # Create u schedule + sched_id
    create_schedule(@u, "FA15", "u sched", true)
    a = { response: response, print: false, success: true }
    res_json = check_response(a)
    u_sched_id = res_json["data"]["schedule"]["id"]

    # Create u2 schedule + sched_id
    create_schedule(@u2, "FA15", "u2 sched", true)
    a.merge!({ response: response })
    res_json = check_response(a)
    u2_sched_id = res_json["data"]["schedule"]["id"]

    # Create u3 schedule + sched_id
    create_schedule(@u3, "FA15", "u3 sched", true)
    a.merge!({ response: response })
    res_json = check_response(a)
    u3_sched_id = res_json["data"]["schedule"]["id"]

    # Add networks and python to u schedule
    add_section_to_schedule(@u, networks.merge({ schedule_id: u_sched_id }))
    add_section_to_schedule(@u, python_class.merge({ schedule_id: u_sched_id }))

    # Now that u has added these to their schedule, we should see them on requesting
    # both courses from the course endpoints
    get "/api/v1/courses/FA15/CS/2850", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Networks"
    pp res_json["data"]["course"]["people_in_course"] # Should just be the one person

    get "/api/v1/courses/FA15/CS/1110", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Python"
    pp res_json["data"]["course"]["people_in_course"]

    # Add networks and python to u2 schedule
    add_section_to_schedule(@u2, networks.merge({ schedule_id: u2_sched_id }))
    add_section_to_schedule(@u2, python_class.merge({ schedule_id: u2_sched_id }))

    # Now that u + u2 has added these to their schedule, we should see them on requesting
    # both courses from the course endpoints
    get "/api/v1/courses/FA15/CS/2850", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Networks"
    pp res_json["data"]["course"]["people_in_course"] # Should just be the one person

    get "/api/v1/courses/FA15/CS/1110", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Python"
    pp res_json["data"]["course"]["people_in_course"]

    # Now, u2 destroys his schedule :(
    destroy_schedule(@u2, u2_sched_id)

    # Only u should come up
    get "/api/v1/courses/FA15/CS/2850", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Networks"
    pp res_json["data"]["course"]["people_in_course"] # Should just be the one person

    get "/api/v1/courses/FA15/CS/1110", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Python"
    pp res_json["data"]["course"]["people_in_course"]

  end

  # More in-depth checking of students in courses (based on semester + active schedule)
  it "Ensures that only students of the course for the viewed semester appear (who have an active schedule w/that course)" do

    # Networks for FA15
    networks_fa15 = {
      :term => "FA15",
      :subject => "CS",
      :number => 2850,
      :crse_id => 359378,
      :section_num => [12447]
    }

    # Networks for FA16
    networks_fa16 = {
      :term => "FA16",
      :subject => "CS",
      :number => 2850,
      :crse_id => 359378,
      :section_num => [11749]
    }

    # Create u schedule for FA15 + sched_id
    create_schedule(@u, "FA15", "u sched for FA15", true)
    a = { response: response, print: false, success: true }
    res_json = check_response(a)
    u_sched_id_fa15 = res_json["data"]["schedule"]["id"]

    # Create u2 schedule for FA15 + sched_id
    create_schedule(@u2, "FA15", "u2 sched for FA15", true)
    a.merge!({ response: response })
    res_json = check_response(a)
    u2_sched_id_fa15 = res_json["data"]["schedule"]["id"]

    # Create u schedule for FA16 + sched_id
    create_schedule(@u, "FA16", "u sched for FA16", true)
    a.merge!({ response: response })
    res_json = check_response(a)
    u_sched_id_fa16 = res_json["data"]["schedule"]["id"]

    # Add Networks (FA15) to u FA15 schedule
    add_section_to_schedule(@u, networks_fa15.clone.merge({ schedule_id: u_sched_id_fa15 }))
    a.merge!({ response: response })
    res_json = check_response(a)

    # Add Networks (FA15) to u2 FA15 schedule
    add_section_to_schedule(@u2, networks_fa15.clone.merge({ schedule_id: u2_sched_id_fa15 }))
    a.merge!({ response: response })
    res_json = check_response(a)

    # Pull the people in Networks for FA15
    get "/api/v1/courses/FA15/CS/2850", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Networks for FA15"
    pp res_json["data"]["course"]["people_in_course"] # Should be u and u2

    # Add Networks (FA16) to u FA16 schedule
    add_section_to_schedule(@u, networks_fa16.clone.merge({ schedule_id: u_sched_id_fa16 }))
    a.merge!({ response: response })
    res_json = check_response(a)

    # Pull the people in Networks for FA16
    get "/api/v1/courses/FA16/CS/2850", common_creds
    a.merge!({ response: response })
    res_json = check_response(a)
    pp "People in Networks for FA16"
    pp res_json["data"]["course"]["people_in_course"] # Should be u only

  end

end
