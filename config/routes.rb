Abchoops::Application.routes.draw do
  devise_for :users

  root to: "games#index"
  
  scope '/admin' do
    get 'recalc-stats' => "stats#recalc_stats"
    
    resources :players
    
    resources :teams do
      member do
        get 'roster/edit' => "rosters#edit"
        post 'roster/edit' => "rosters#add"
        put 'roster/edit' => "rosters#edit_number"
        delete 'roster/edit' => "rosters#remove"
      end
    end
    put "teams" => "teams#save_changes"
    
    resources :games do
      member do
        get 'boxscore' => "boxscores#show"
        get 'boxscore/edit' => "boxscores#edit"
        put 'boxscore/edit' => "boxscores#update"
      end
      collection do
        get 'resave' => "games#resave"
      end
    end
    
    resources :seasons do
      member do
        get 'teams/edit' => "team_lists#edit", as: "team_list_edit"
        post 'teams/edit' => "team_lists#add"
        delete 'teams/edit' => "team_lists#remove"
        put 'teams/edit' => "team_lists#set_division", as: "division_edit"
      end
      resources :divisions
    end
    put 'seasons' => "seasons#set_current"
    
    resources :locations
    
    resources :dates, only: [:index, :create, :destroy] do
      collection do
        get 'edit' => "dates#edit"
        put '' => "dates#update"
      end
    end
  end
  
  #add scope
  get 'games/:id/boxscore' => "stats#show_boxscore", as: "stats_boxscore"
  get 'teams/:id' => "stats#show_team", as: "stats_team"
  get 'players/:id' => "stats#show_player", as: "stats_player"
  
  # The priority is base d upon order of creation:
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
