FactoryGirl.define do
  game_info = { :time => "12:00PM", :home_team_id => 1, :away_team_id => 2 }
  games_hash = { :game0 => game_info }
  factory :game do
    location_id 1
    season_id 1
    league_id 1
    date "12/25/2016"
    games games_hash
    # games {{ 
    #   game0 {{ 
    #     time: "12:00PM" 
    #     }} 
    #   }}
    # games {{ time: "12:00PM" }} WORKS WORKS
      # {{
      #   "time" => "12:00PM"
      #   "home_team_id" => "1"
      #   "away_team_id" => "2"
      #   }}
      # }}
  end
end