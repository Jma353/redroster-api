#!/bin/bash 

# $1 - :token_id 
data='{ "api_key": "'"$1"'", "id_token": "'"$2"'"}'

echo $data

curl -H "Accept: application/json" \
-H "Content-type: application/json" \
-X POST \
-d "$data" \
-v http://localhost:3000/api/v1/schedules/create

