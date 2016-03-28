#!/bin/bash 

# $1 - api_key (given by the api)
# $2 - id_token (to gain access to a specific set of user credentials)
# $3 - schedule_id (to grab a schedule)
# $4 - section -> section_num (5-digit section number specific to the course)
data='{ "api_key": "'"$1"'", "id_token": "'"$2"'", "schedule_id": "'"$3"'", "section": { "section_num": '"$4"' }}'

echo $data

curl -H "Accept: application/json" \
-H "Content-type: application/json" \
-X DELETE \
-d "$data" \
-v http://localhost:3000/api/v1/schedule_elements/delete

