# == Schema Information 
# 
#  Table Name: users
#  
#  id     		 				:integer 				 	 	not null, PRIMARY KEY 
#  google_token				:string 				 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 			 	 	not null 


class User < ActiveRecord::Base

end
