Personalsite::Application.routes.draw do
  root to: 'high_voltage/pages#show', id: 'home'
  match '/games' => 'high_voltage/pages#show', as: :static, id: 'games_index'
  match '/resume' => 'high_voltage/pages#show', as: :static, id: 'resume'
  match '/resumes' => 'high_voltage/pages#show', as: :static, id: 'resume'
  resources :contacts
  match '/contact', to: 'deprecated_contacts#new'
  #games
  match '/lightseeker' => 'high_voltage/pages#show', as: :static, id: 'lightseeker'
  match '/cat4' => 'high_voltage/pages#show', as: :static, id: 'cat4'
  match '/sectarian' => 'high_voltage/pages#show', as: :static, id: 'sectarian'
  match '/blowback' => 'high_voltage/pages#show', as: :static, id: 'blowback'
  match '/boundaries' => 'high_voltage/pages#show', as: :static, id: 'boundaries'
  match '/numbernommers' => 'high_voltage/pages#show', as: :static, id: 'numbernommers'
  match '/numbernommers2' => 'high_voltage/pages#show', as: :static, id: 'numbernommers2'
  match '/tat' => 'high_voltage/pages#show', as: :static, id: 'tat'
  match '/vengeance' => 'high_voltage/pages#show', as: :static, id: 'vengeance'
  match '/blowback/making_of' => 'high_voltage/pages#show', as: :static, id: 'making_of_blowback/1'
  match '/blowback/making_of/1' => 'high_voltage/pages#show', as: :static, id: 'making_of_blowback/1'
  match '/blowback/making_of/2' => 'high_voltage/pages#show', as: :static, id: 'making_of_blowback/2'
  match '/blowback/making_of/3' => 'high_voltage/pages#show', as: :static, id: 'making_of_blowback/3'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
