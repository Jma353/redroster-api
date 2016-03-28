Rails.application.routes.draw do


  namespace :api do 
    namespace :v1 do 



      post "sign_in" => "users#google_sign_in"

      post "schedules/create" => "schedules#create"

      delete "schedules/delete" => "schedules#destroy"

      post "schedule_elements/create" => "schedule_elements#create"

      delete "schedule_elements/delete" => "schedule_elements#destroy"

      # All search stuff 

      get "search/:term/:query" => "courses#search_courses"

      get "courses/" => "courses#list_of_terms"

      get "courses/:term" => "courses#subjects_by_term"

      get "courses/:term/:subject" => "courses#courses_by_subject"

      get "courses/:term/:subject/:number" => "courses#course_info"




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
