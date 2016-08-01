# Controller to handle our static, landing pages 
require 'mailchimp'
class StaticPagesController < ApplicationController

	def home 
		# mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
		@email = params[:email]
		result = !(@email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i).nil?

		# Respond accordingly 
		respond_to do |f|
			f.html 
			f.json { render json: { fuck: result }}
		end 

	end 

	def privacy 
	end 

	def about
	end 

	def acknowledgements 
	end 


end
