# Red Roster Backend 

## Backend for Red Roster iOS app 


## Endpoints 

* POST `/api/v1/sign_in` => Sign in validation 
* POST `/api/v1/schedules/create` (not ready for production use)
* DELETE `/api/v1/schedules/delete` (not ready for production use)
* GET `/api/v1/courses` => List of terms that offer courses 
* GET `/api/v1/courses/:term` => List of subjects that offer courses in a given term 
* GET `/api/v1/courses/:term/:subject` => List of courses offered for a particular subject in a given term 
* GET `/api/v1/courses/:term/:subject/:number` => In-depth course information (number is 4-digit number of course, NOT ID #)

NOTE: all endpoints require api_key and id_token parameters w/in HTTP request body 
