# Controller to handle our static, landing pages 
class StaticPagesController < ApplicationController

	def home 
		@email = params[:email]
		result = !((@email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i).nil?) 
		data = result ? BetaTester.create({ email: @email }) : { error: "Please enter a valid email" }
		if result 
			if data.errors.any?
				data = { error: "You have already signed up for the beta" }
				result = false 
			end 
		end 
		respond_to do |f|
			f.html 
			f.json { render json: { success: result, data: data }}
		end 

	end 

	def privacy 
	end 

	def about
	end 

	def acknowledgements 
	end 

	def beta
		@pass = params[:pass]
		result = @pass == ENV['BETA_LIST_PASS']
		data = result ? BetaTester.all.map { |bt| BetaTesterSerializer.new(bt).as_json["beta_tester"] } : { error: "You are not authorized to see this" }

		# Respond accordingly 
		respond_to do |f| 
			f.html 
			f.json { render json: { success: result, data: data }}
		end 

	end 


end
