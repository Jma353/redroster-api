#!/bin/bash 

data='{ "api_key": "'"$1"'", "id_token": "'"$2"'", "schedule_id": "'"$3"'"}'

echo $data

curl -H "Accept: application/json" \
-H "Content-type: application/json" \
-X DELETE \
-d "$data" \
-v http://localhost:3000/api/v1/schedules/delete



