# == Schema Information
#
# Table name: courses
#
#  id                  :integer          not null, primary key
#  crse_id             :integer
#  term                :string
#  subject             :string
#  catalog_number      :integer
#  course_offer_number :integer
#  credits_maximum     :integer
#  credits_minimum     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

include SectionsHelper
module CoursesHelper


  # Helper method, constructs the course given the Cornell Courses API response + term
  def build_course(course_info, term)
    # Course JSON necessary to build the course
    course_json = {
      crse_id: course_info["crseId"],
      term: term,
      title: course_info["titleShort"],
      subject: course_info["subject"],
      course_offer_number: course_info["crseOfferNbr"],
      catalog_number: course_info["catalogNbr"].to_i,
      credits_maximum: course_info["enrollGroups"][0]["unitsMaximum"],
      credits_minimum: course_info["enrollGroups"][0]["unitsMinimum"],
    }

    @course = Course.find_by(:term => course_json[:term], :crse_id => course_json[:crse_id])
    if @course.blank?
      @course = Course.create(course_json)
    end
    return @course
  end


  # Helper method, constructs the course given the Cornell Courses API response + term
  # and builds all sections corresponding to that course
  def build_course_and_sections(course_info, term)
    @course = build_course(course_info, term)
    # Iterate through all the sections to add these
    sections = []
    (0...course_info["enrollGroups"].length).each do |i|
      sections = sections.concat(build_sections(course_info["enrollGroups"][i]["classSections"], @course, i+1))
    end
    return [@course, sections]
  end


   # Helper method, queries the Cornell Courses API given term, subject, and number
   def get_course_info(term, subject, number)
     # Get the level we care about
     course_level = (number.to_i / 1000) * 1000
    # Format them into a URL string + make a request to Cornell API
    url_string = "https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&classLevels[]=#{course_level}"
    uri = URI(url_string)

    # Handle catching errors on Cornell's end
    res_json = nil
    begin
      res_json = JSON.parse(Net::HTTP.get(uri))
    rescue => error
      return nil
    end

    # Check to see if the request was successful and that the course actually exists amongst the response
    if res_json["status"] != "success" && (find_course_index(res_json, number) == -1)
      render json: { success: false, data: { errors: ["Your requested credentials match no courses"] }} and return
    else
      # Find the course's index in the response
      c_index = find_course_index(res_json, number)
      # If we couldn't find the course
      if c_index == -1
        return nil
      end
      return res_json["data"]["classes"][c_index]
    end
   end


  # Less course information
  def format_course_less(c)
    course_and_section = build_course_and_sections(c, c["term"])
    @course = course_and_section[0]
    sections = course_and_section[1]
    course_json = {
      crse_id: c["crseId"], # 123456, unique
      subject: c["subject"], # CS, ORIE, etc.
      catalog_number: c["catalogNbr"], # 1110, 4999, etc.
      title_short: c["titleShort"], # Shorter title
      course_offer_number: c["crseOfferNbr"],
      title_long: c["titleLong"], # Longer title
      description: c["description"], # Description of course
    }

    return [course_json, sections]
  end



  # More course information
  # Prereq: need term info
  def format_course(c)
    haha = format_course_less(c)
    course_json = haha[0]
    sections = haha[1]

    # Course JSON
    course_json.merge!({
      term: c["term"],
      prerequisites: c["catalogPrereqCoreq"], # Prereqs
      credits_minimum: c["enrollGroups"][0]["unitsMinimum"], # minimum units of this course
      credits_maximum: c["enrollGroups"][0]["unitsMaximum"], # maximum units of this course
      required_sections: c["enrollGroups"][0]["componentsRequired"], # components required (e.g. LEC, DIS, etc.)
      begin_date: c["enrollGroups"][0]["sessionBeginDt"], # begin date
      end_date: c["enrollGroups"][0]["sessionEndDt"], # end data
      grading_basis: c["enrollGroups"][0]["gradingBasis"], # OPT or SUS
      cross_listings: c["enrollGroups"][0]["simpleCombinations"] # Crosslistings
    })

    course_json[:cross_listings] << { "subject" => c["subject"], "catalogNbr" => c["catalogNbr"] }
    course_json[:people_in_course] = @course.users.map {|u| UserSerializer.new(u).as_json["user"] }
    course_json[:sections] = sections.map { |s| SectionSerializer.new(s).as_json["section"] }
    course_json

  end


  # Get a list of subjects
  def query_subjects(term, query)
    uri = URI("https://classes.cornell.edu/api/2.0/config/subjects.json?roster=#{term}")
    subject_json = JSON.parse(Net::HTTP.get(uri))
    subjects = []
    if subject_json["status"] != "error"
      subject_json["data"]["subjects"].each do |s|
        if s["value"].include?(query) # could do include? for more comprehensive search results
          subjects.push({ subject: { value: s["value"], descr: s["descr"] } })
        end
      end
    end
    subjects
  end


  # Method to curate courses based upon the number that has been given in the query
  def num_compare(num, c)
    return true if num == nil # if no number was provided
    course_num = Integer(c["catalogNbr"])
    div = 1000
    while(div > 0) do
      if num == course_num/div
        return true
      end
      div = div / 10
    end
    return false
  end


  def query_courses(term, subjects, q_num)
    courses = []
    subjects.each do |s|
      subject_uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{s}")
      course_json = JSON.parse(Net::HTTP.get(subject_uri))
      if course_json["status"] != "error"
        courses_info = course_json["data"]["classes"]
        courses_info.each do |ci|
          if num_compare(q_num, ci)
            ci["term"] = term
            result_json = format_course_less(ci)[0]
            courses.push(result_json)
          end
        end
      end
    end
    courses
  end


  # Check a full list of queried courses for the course we're looking for
  def find_course_index(cl_json, num)
    classes = cl_json["data"]["classes"]
    (0...classes.length).each do |i|
      if classes[i]["catalogNbr"].to_i == num.to_i
        return i
      end
    end
    return -1
  end








end
