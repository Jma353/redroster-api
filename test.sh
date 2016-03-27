#!/bin/bash 

# $1 - :token_id 
data='{ "api_key": "'"$1"'" }'

echo $data

curl -H "Accept: application/json" \
-H "Content-type: application/json" \
-X GET \
-d "$data" \
-v http://localhost:3000/api/v1/courses/

