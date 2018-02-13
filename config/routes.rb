Abchoops::Application.routes.draw do
  devise_for :users

  root to: "stats#show_results"
  
  get '/admin' => "games#index", as: "users_root"
  scope '/admin' do    
    get '' => "games#index", as: "admin_root"
    
    resources :players do
      collection do
        get 'datatables' => "players#datatables", as: "datatables"
        get 'merge' => "players#merge", as: "merge"
        put 'merge' => "players#merge_players"
      end
    end
    
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
        get 'clear_photos'
      end
      collection do
        get 'resave' => "games#resave"
        delete 'remove_url' => "games#remove_url"
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
  
  #get 'index' => "stats#index", as: "index"
  #get 'the-league' => "stats#info"
  #get 'news' => "stats#news"
  #get 'media' => "stats#media"
  #get 'store' => "stats#store"
  get 'games/:id/boxscore' => "stats#show_boxscore", as: "stats_boxscore"
  get 'teams/:id' => "stats#show_team", as: "stats_team"
  get 'players/:id' => "stats#show_player", as: "stats_player"
  get 'schedules' => "stats#show_schedules", as: "schedules"
  get 'results' => "stats#show_results", as: "results"
  get 'record-books' => "stats#show_record_books", as: "record_books"
  get 'player-search' => "stats#player_search"
  get 'api/standings' => "stats#get_standings"
  get 'api/players' => "stats#get_players"
  
  get '*path' => redirect("http://www.abchoopsnyc.com")
  
end
