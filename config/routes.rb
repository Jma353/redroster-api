Rails.application.routes.draw do

  # Don't need this for our documentation 
  # apipie

  
  namespace :api do 
    namespace :v1 do 



      # Sign In 

      post "sign_in" => "users#google_sign_in", :as => 'sign_in' 

      get "users/search/:query" => "users#people_search", :as => 'users_search'

      

      # Schedules 

      get "schedules/index/:user_id" => "schedules#index", :as => 'schedules_index'

      post "schedules/create" => "schedules#create", :as => 'schedules_create'

      get "schedules/show/:id" => "schedules#show", :as => 'schedules_show'

      post "schedules/make_active/:id" => "schedules#make_active", :as => 'schedules_make_active'

      post "schedules/clear/:id" => "schedules#clear", :as => 'schedules_clear'

      delete "schedules/delete/:id" => "schedules#destroy", :as => 'schedules_destroy'



      # Schedule Elements 

      post "schedule_elements/create" => "schedule_elements#create", :as => 'schedule_elements_create'

      delete "schedule_elements/delete" => "schedule_elements#destroy", :as => 'schedule_elements_destroy'



      # All search stuff/fetching of terms, subjects, and courses 

      get "courses/search/:term/:query" => "courses#search_courses", :as => 'search_courses_by_term' 

      get "courses/search_by_subject/:term/:query" => "courses#search_subjects", :as => 'search_for_subjects' 

      get "courses/" => "courses#list_of_terms", :as => 'courses_terms'

      get "courses/:term" => "courses#subjects_by_term", :as => 'courses_by_term' 

      get "courses/:term/:subject" => "courses#courses_by_subject", :as => 'courses_by_term_subject' 

      get "courses/:term/:subject/:number" => "courses#course_info", :as => 'courses_by_term_subject_number' 



      # Course reviews 

      post "course_reviews/create" => "course_reviews#create", :as => 'course_reviews_create'

      get "course_reviews/:crse_id" => "course_reviews#reviews_by_course", :as => 'course_reviews_by_course'

      get "course_reviews/can_review/:crse_id" => "course_reviews#can_review", :as => 'course_reviews_can_review'

      get "course_reviews/specific_review/:course_review_id" => "course_reviews#specific_review", :as => 'course_review_for_course'

      delete "course_reviews/delete/:course_review_id" => "course_reviews#destroy", :as => 'course_reviews_destroy'



      # Following requests 

      post "following_requests/create" => "following_requests#create", :as => "create_following_request"

      post "following_requests/react_to_request/:accept" => "following_requests#react_to_request", :as => "react_to_following_request"

      

      # Followings 

      get "followings/fetch_followers" => "followings#fetch_followers", :as => "fetch_followers"

      get "followings/fetch_followees" => "followings#fetch_followees", :as => "fetch_followees"

      get "followings/fetch_followings" => "followings#fetch_followings", :as => "fetch_followings"



    end 
  end 


end








