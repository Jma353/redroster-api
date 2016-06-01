# Red Roster Backend 

# Backend for Red Roster iOS app 


# Endpoints 
## Sign In 

POST `/api/v1/sign_in` : Sign in validation 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" }



## Schedules

GET `api/v1/schedules/index` : Show logged in user's schedules 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" }

POST `/api/v1/schedules/create` : Create a schedule for a specific term 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" schedule: { term: "FA16", name: "My crazzzaay schedule", is_active: true } } 

GET `/api/v1/schedules/show/:id` : Returns a formatted schedule ready for easy parsing.  
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" } 

POST `api/v1/schedules/clear/:id` : Clear the schedule specified of all schedule_elements 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" }
	
DELETE `/api/v1/schedules/delete/:id` : Delete a schedule (cascades as well)
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" } 
	


## Schedule Elements 

POST `/api/v1/schedule_elements/create` (not ready for production use)
##### HTTP Request Body
	{ 
	  	api_key: "XYZ", 
	  	id_token: "ABC", 
	  	schedule_element: 	{ 
	  							schedule_id: 1
	  							term: "SP16",
	  							subject: "CS",
	  							course_num: 1110,
	  							section_num: [11828, XXXXX, ...] // Specific to the course (must be an array)
	  						}	
	}

DELETE `/api/v1/schedule_elements/delete` (not ready for production use)
##### HTTP Request Body
	{ 	
		api_key: "XYZ",
	  	id_token: "ABC",
	 	schedule_element: 	{ 
	 							schedule_id: 1,
	 							id: 44 // The schedule_element primary key
	 						} 
	}



## Courses 

GET `/api/v1/courses` : List of terms that offer courses 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/courses/:term` : List of subjects that offer courses in a given term 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/courses/:term/:subject` : List of courses offered for a particular subject in a given term 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/courses/:term/:subject/:number` : In-depth course information (number is 1000..9999, not id #)
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/search/:term/:query` : Search results for all-purpose course query (e.g. "ORIE3120", "ORI", "CS11", etc.) 
##### HTTP Request Body	
	{ api_key: "XYZ", id_token: "ABC" } 
	
GET `/api/v1/search_by_subject/:term/:query` : Search subjects of a particular term based upon any search query.  Returns value/descr of the subject namespaced under "subject."
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC" }
	
 
 
## Course Reviews 

POST `/api/v1/course_reviews/create` : Create a review for a specific course 
##### HTTP Request Body
	{ 
	  	api_key: "XYZ", 
	  	id_token: "ABC",
	  	course_review: 	{ 
	  						subject: "CS", 
	  						number: 1110, 
	  						term: "FA15",
	  						lecture_score: [1-10],
	  						office_hours_score: [1-10],
	  						difficulty_score: [1-10],
	  						material_score: [1-10],
	  						feedback: "Max 200 char feedback" 
	  				  	} 
	 } 
	 
	 
GET `/api/v1/course_reviews/by_course` : View reviews/overall averages for review metrics given a course subject and number 
##### HTTP Request Body
	{ 
		api_key: "XYZ", 
	  	id_token: "ABC", 
	  	course_review: { subject: "CS", number: 1110 } } 


GET `/api/v1/course_reviews/specific_review` : View review for a course given course subject, number, and course_review_id 
##### HTTP Request Body
	{ 
		api_key: "XYZ", 
	 	id_token: "ABC", 
	  	course_review: { subject: "CS", number: 1110, course_review_id: 100 } } 	  

DELETE `/api/v1/course_reviews/delete` : Delete a review for a specific course 
##### HTTP Request Body
	{ api_key: "XYZ", id_token: "ABC", course_review: { master_course_id: 123 } }
	


## Following Requests 


POST `api/v1/following_requests/create` : Send a request to follow someone 
##### HTTP Request Body
	{
		api_key: "XYZ", 
		id_token: "ABC", 
		following_request: { user_id: 123 }
	}


POST `api/v1/following_requests/react_to_request/:accept(true or false)` : Accept or reject a following request to you
##### HTTP Request Body
	{
		api_key: "XYZ", 
		id_token: "ABC",
		following_requests: { id: 40 // Unique id, can be pulled from viewing the request on the frontend } 
	}



## Followings 


GET `api/v1/followings/fetch_followers` : Get a list of your follows 
##### HTTP Request Body
	{
		api_key: "XYZ",
		id_token: "ABC" 
	}


GET `api/v1/followings/fetch_followees` : Get a list of the people you follow 
##### HTTP Request Body
	{
		api_key: "XYZ", 
		id_token: "ABC"
	}


GET `api/v1/followings/fetch_followings` : Get a list of the relationships you have 
##### HTTP Request Body 
	{
		api_key: "XYZ", 
		id_token: "ABC"
	}













