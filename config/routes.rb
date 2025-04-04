Rails.application.routes.draw do
  resources :rulebooks, only: %i[index new create show]

  require 'sidekiq/web'
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ApartmentAcmeClient::Engine => '/aac'

  resources :admin_upgrades, only: %i[new create]
  resources :configurations, except: %i[index new create]
  resources :proposals, except: %i[index new create] do
    collection do
      get 'passed'
    end
    member do
      put 'set_voting', to: 'proposal_progress#set_voting'
      put 'set_review', to: 'proposal_progress#set_review'
      put 'set_pre_voting', to: 'proposal_progress#set_pre_voting'
      put 'table', to: 'proposal_progress#table'
    end
    resources :votes, except: [:show]
    resources :revisions, except: %i[edit index put destroy]
  end

  resources :discussions, only: [:show] do
    put :close, on: :member
    resources :comments, only: [:create]
  end

  resources :committees do
    collection do
      get 'membership'
    end
    resources :committee_members, except: [:show]
    resources :discussions, only: %i[create new]
    resources :proposals, only: %i[new create]
  end
  resources :bulk_users, only: %i[index create]
  resources :statistics, only: :index
  namespace :admin do
    resources :users, only: %i[edit update destroy]
  end

  as :user do
    patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  devise_for :users, controllers: { registrations: 'registrations', confirmations: 'confirmations'}

  # this causes devise to direct just-signed-in-users to the welcome/index
  # get 'welcome/index' => "welcome#index", as: :user_root

  get "welcome/index_all"
  get "welcome/help"
  get "welcome/message"
  post "welcome/send_message"

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

  get "/new", to: redirect("/rulebooks")
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  get '/r/:rulebook_slug/(*other)' => "welcome#new_location" # }redirect("/r/%{rulebook_slug}/welcome/index") # to match /en  to send to /en/welcome
  root to: 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
