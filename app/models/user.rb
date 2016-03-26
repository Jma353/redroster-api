# == Schema Information 
# 
#  Table Name: users
#  
#  id     		 				:integer 				 	 	not null, PRIMARY KEY 			 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 			 	 	not null 


class User < ActiveRecord::Base


	# Get this user's session 
	def session 
		Session.find_by_user_id(self.id)
	end 



end
