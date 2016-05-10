Rails.application.routes.draw do


  namespace :api do 
    namespace :v1 do 

      # Sign In // work 

      post "sign_in" => "users#google_sign_in"

      post "users/create" => "users#create"



      # Schedules // work 

      get "schedules/index" => "schedules#index", :as => "schedules_index"

      post "schedules/create" => "schedules#create", :as => 'schedules_create'

      get "schedules/show/:id" => "schedules#show", :as => 'schedules_show'

      delete "schedules/delete/:id" => "schedules#destroy", :as => 'schedules_destroy'



      # Schedule Elements // work 

      post "schedule_elements/create" => "schedule_elements#create", :as => 'schedule_elements_create'

      delete "schedule_elements/delete" => "schedule_elements#destroy", :as => 'schedule_elements_destroy'



      # All search stuff/fetching of terms, subjects, and courses // work  

      get "search/:term/:query" => "courses#search_courses", :as => 'search_by_term'

      get "search_by_subject/:term/:query" => "courses#search_subjects", :as => 'search_by_term_and_subject'

      get "courses/" => "courses#list_of_terms", :as => 'courses_terms'

      get "courses/:term" => "courses#subjects_by_term", :as => 'courses_by_term'

      get "courses/:term/:subject" => "courses#courses_by_subject", :as => 'courses_by_term__subject'

      get "courses/:term/:subject/:number" => "courses#course_info", :as => 'courses_by_term_subject_number'



      # Course reviews // need to test these more

      post "course_reviews/create" => "course_reviews#create", :as => 'course_reviews_create'

      get "course_reviews/by_course" => "course_reviews#reviews_by_course", :as => 'course_reviews_by_course'

      get "course_reviews/specific_review" => "course_reviews#specific_review", :as => 'course_review_for_course'

      delete "course_reviews/delete" => "course_reviews#destroy", :as => 'course_reviews_destroy'



      # Following requests // need to test these 

      post "following_requests/create" => "following_requests#create", :as => 'create_following_request'

      post "following_requests/react_to_request/:accept" => "following_requests#react_to_request", :as => "react_to_following_request"




    end 
  end 


end








