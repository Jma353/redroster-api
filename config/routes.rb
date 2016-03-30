Rails.application.routes.draw do


  namespace :api do 
    namespace :v1 do 



      post "sign_in" => "users#google_sign_in"

      # Schedules

      post "schedules/create" => "schedules#create", :as => 'schedules_create'

      get "schedules/show/:schedule_id" => "schedules#show", :as => 'schedules_show'

      delete "schedules/delete" => "schedules#destroy", :as => 'schedules_destroy'

      # Schedule Elements 

      post "schedule_elements/create" => "schedule_elements#create", :as => 'schedule_elements_create'

      delete "schedule_elements/delete" => "schedule_elements#destroy", :as => 'schedule_elements_destroy'

      # All search stuff/fetching of terms, subjects, and courses 

      get "search/:term/:query" => "courses#search_courses", :as => 'search_by_term'

      get "search_by_subject/:term/:query" => "courses#search_subjects", :as => 'search_by_term_and_subject'

      get "courses/" => "courses#list_of_terms", :as => 'courses_terms'

      get "courses/:term" => "courses#subjects_by_term", :as => 'courses_by_term'

      get "courses/:term/:subject" => "courses#courses_by_subject", :as => 'courses_by_term__subject'

      get "courses/:term/:subject/:number" => "courses#course_info", :as => 'courses_by_term_subject_number'


      # Course reviews 

      post "course_reviews/create" => "course_reviews#create", :as => 'course_reviews_create'

      get "course_reviews/by_course" => "course_reviews#reviews_by_course", :as => 'course_reviews_by_course'

      delete "course_reviews/delete" => "course_reviews#destroy", :as => 'course_reviews_destroy'


    end 
  end 




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end



end
