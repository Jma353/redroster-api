# == Schema Information 
# 
#  Table Name: section 
#  
#  section_num :integer					 not null, PRIMARY KEY 
#  created_at  :datetime				 not null
#  updated_at  :datetime 				 not null 


class Section < ActiveRecord::Base

	validates :section_num, presence: true 




end
