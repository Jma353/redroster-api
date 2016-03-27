#!/bin/bash 

# $1 - :token_id 
data='{ "token_id": "'"$1"'" }'

curl -H "Accept: application/json" \
-H "Content-type: application/json" \
-X POST \
-d "$data" \
-v http://localhost:3000/api/v1/sessions/google_id