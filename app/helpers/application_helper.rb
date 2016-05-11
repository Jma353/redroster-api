module ApplicationHelper


	# Get or create a course
	def get_or_create_course(course_info, term, subject, course_num)

		# Attempts to find the course 
		@course = Course.find_by_course_id(course_info["crseId"])

		# If the course was not found in the DB
		if @course.blank? 
			course_json = { 
				course_id: course_info["crseId"], 
				term: term, 
				subject: subject, 
				number: course_num, 
				credits_maximum: course_info["enrollGroups"][0]["unitsMaximum"], 
				credits_minimum: course_info["enrollGroups"][0]["unitsMinimum"]
			}

			# Create the course
			@course = Course.new(course_json)


			# Create a listing of all possible cross-listings 
			possible_listings = [{ subject: subject, number: course_num }]
			cross_listings = course_info["enrollGroups"][0]["simpleCombinations"]
			cross_listings.each { |c| possible_listings << { subject: c["subject"], number: c["catalogNbr"].to_i }}
			
			# Get the master_course
			@master_course = get_or_create_master_course(possible_listings)	

			# Set the course's :master_course_id field 
			@course.master_course_id = @master_course.id 
			# Save the course to the DB 
			@course.save 
		end 
		@course

	end


	# Prerequisite: cross_listings.length >= 1 
	# Gets or creates a @master_course
	def get_or_create_master_course(cross_listings)

		# Find the course or not (querying the DB in helper function)
		master_course = find_master_course(cross_listings)

		# If the master_course does not exist in the DB, make it given the first 
		# cross listing provided (this is always guaranteed to be present)
		if master_course.blank? 
			subject = cross_listings[0][:subject]
			number = cross_listings[0][:number]
			master_course = MasterCourse.create(subject: subject, number: number)
		end

		# Return the master_course we got before or just created 
		master_course
	end 


	## SEARCH METHODS 


	# Finds a master_course from a series of cross_listings, or returns nil 
	# if it's not found 
	def find_master_course(cross_listings)
		cross_listings.each do |cl|
			mc = MasterCourse.find_by(subject: cl[:subject], number: cl[:number])
			if !mc.blank? 		
				return mc 
			end  
		end 
		return nil 
	end







end
