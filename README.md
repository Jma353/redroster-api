# Red Roster Backend 

## Backend for Red Roster iOS app 


## Endpoints 


POST `/api/v1/sign_in` : Sign in validation 
	
	{ api_key: "XYZ", id_token: "ABC" }

POST `/api/v1/schedules/create` (not ready for production use)

	{ api_key: "XYZ", id_token: "ABC" } 
	
DELETE `/api/v1/schedules/delete` (not ready for production use)

	{ api_key: "XYZ", id_token: "ABC", schedule_id: 1 } 
	
POST `api/v1/schedule_elements/create` (not ready for production use)

	{ 
	  api_key: "XYZ", 
	  id_token: "ABC", 
	  schedule_id: 1, 
	  section: { 
	  				term: "SP16",
	  				subject: "CS",
	  				course_num: 1110,
	  				section_num: 11828 // Specific to the course 
	  	
	  			}
	 }
	 
DELETE `api/v1/schedule_elements/delete` (not ready for production use)

	{ api_key: "XYZ",
	  id_token: "ABC",
	  schedule_id: 1,
	  section: { section_num: 11828 } 
	
GET `/api/v1/courses` : List of terms that offer courses 

	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/courses/:term` : List of subjects that offer courses in a given term 

	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/courses/:term/:subject` : List of courses offered for a particular subject in a given term 

	{ api_key: "XYZ", id_token: "ABC" } 

GET `/api/v1/courses/:term/:subject/:number` : In-depth course information (number is 1000..9999, not id #)

	{ api_key: "XYZ", id_token: "ABC" } 






