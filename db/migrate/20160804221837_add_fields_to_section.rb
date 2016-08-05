class AddFieldsToSection < ActiveRecord::Migration
  def change
  	add_column :sections, :topic_description, :string
  	add_column :sections, :enroll_group, :integer

  	# Update all sections accordingly 
  	Section.all.each do |s|
  		s.update_attributes!(:topic_description => "", :enroll_group => 1)
  	end 


  end
end
