RulebookApp::Application.routes.draw do

  resources :rulebooks, only: [:index, :new, :create, :show]

  scope "/r/(:rulebook_slug)" do
    resources :admin_upgrades, only: [:new, :create]
    resources :configurations, except: [:index, :new, :create]
    resources :proposals, :except => [:index, :new, :create] do
      collection do
        get 'passed'
      end
      member do
        put 'set_voting'
        put 'set_review'
        put 'set_pre_voting'
        put 'table'
      end
      resources :votes, :except => [:show]
      resources :revisions, :except => [:edit, :index, :put, :destroy]
    end

    resources :discussions, only: [:show] do
      put :close, on: :member
     resources :comments, :only => [:create]
    end

    resources :committees do
      collection do
        get 'membership'
      end
      resources :committee_members, :except => [:show]
      resources :discussions, only: [:index, :create, :new]
      resources :proposals, only: [:new, :create]
    end

    devise_for :users, :controllers => {:confirmations => 'confirmations'}

    devise_scope :user do
      patch "/confirm" => "confirmations#confirm"
    end

    # this causes devise to direct just-signed-in-users to the welcome/index
    get 'welcome/index' => "welcome#index", as: :user_root

    get "welcome/index"
    get "welcome/help"
    get "welcome/message"
    post "welcome/send_message"
  end

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
  get '/r/:rulebook_slug' => redirect("/r/%{rulebook_slug}/welcome/index") # to match /en  to send to /en/welcome
  root :to => 'welcome#index_all'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
