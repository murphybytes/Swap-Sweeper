Ssrails::Application.routes.draw do
  get "account/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'account/logout' => 'account#logout', :as => :account_logout
  match 'account/login' => 'account#login', :as => :account_login
  match 'account/bids/received' => 'account#bids_received', :as => :bids_received
  match 'account/bids/offered' => 'account#bids_offered', :as => :bids_offered
  match 'account/:id/picture' => 'account#picture', :as => :profile_picture
  match 'invite' => 'account#invite', :as => :invite
  match 'auctions/:id/bid' => 'auctions#bid', :as => :bid
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :offerings
  resources :photos
  resources :messages
  resources :auctions do
    resources :bids
  end


  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to => 'account#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
