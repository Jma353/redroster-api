Apipie.configure do |config|
	config.app_name                = "RedrosterBackend"
	config.api_base_url            = "/api"
	config.doc_base_url            = "/apipie"
	# where is your API defined?
	config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
	
	# what markup are we using? 
	config.markup                  = Apipie::Markup::Markdown.new
end
