# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131211080429) do

  create_table "abc_plus_scores", :force => true do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.float    "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "career_highs", :force => true do |t|
    t.integer  "player_id"
    t.string   "description"
    t.float    "value"
    t.string   "game"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "stat_type"
    t.integer  "game_id"
  end

  add_index "career_highs", ["player_id"], :name => "index_career_highs_on_player_id"

  create_table "date_ranges", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.boolean  "playoffs"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "season_id"
    t.string   "short_name"
    t.integer  "league_id"
  end

  create_table "divisions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.integer  "season_id"
  end

  create_table "games", :force => true do |t|
    t.integer  "season_id"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.datetime "date"
    t.time     "time"
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "home_score_first"
    t.integer  "home_score_second"
    t.integer  "away_score_first"
    t.integer  "away_score_second"
    t.integer  "location_id"
    t.integer  "home_score_ot_one"
    t.integer  "home_score_ot_two"
    t.integer  "home_score_ot_three"
    t.integer  "away_score_ot_one"
    t.integer  "away_score_ot_two"
    t.integer  "away_score_ot_three"
    t.boolean  "forfeit"
    t.integer  "winner"
    t.integer  "league_id"
    t.integer  "division_id"
    t.string   "playoff_round"
  end

  add_index "games", ["season_id"], :name => "index_games_on_season_id"

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "short_name"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "player_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.float    "points"
    t.integer  "team_id"
    t.float    "fgm"
    t.float    "fga"
    t.float    "fgpct"
    t.float    "threem"
    t.float    "threea"
    t.float    "threepct"
    t.float    "ftm"
    t.float    "fta"
    t.float    "ftpct"
    t.float    "orb"
    t.float    "drb"
    t.float    "trb"
    t.float    "ast"
    t.float    "stl"
    t.float    "blk"
    t.float    "fl"
    t.float    "to"
    t.float    "twom"
    t.float    "twoa"
    t.float    "twopct"
    t.integer  "game_count"
    t.string   "stat_type"
    t.string   "split_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "season_number"
    t.integer  "league_id"
    t.integer  "double_double"
  end

  add_index "player_stats", ["player_id", "stat_type", "season_id"], :name => "index_player_stats_on_player_id_and_stat_type_and_season_id"
  add_index "player_stats", ["team_id", "stat_type", "season_id"], :name => "index_player_stats_on_team_id_and_stat_type_and_season_id"

  create_table "players", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "height"
    t.integer  "weight"
    t.integer  "age"
    t.string   "key"
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.integer  "team_id"
    t.integer  "number"
    t.integer  "height_feet"
    t.integer  "height_inches"
    t.string   "school"
    t.string   "position"
    t.string   "hometown"
    t.text     "about"
    t.string   "day_job"
    t.date     "birthday"
    t.string   "profile_pic_url"
    t.string   "profile_pic_flickr_url"
    t.text     "social_media_urls"
    t.string   "profile_pic_thumb_url"
    t.string   "display_name"
  end

  create_table "roster_spots", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "season_id"
    t.integer  "jersey_number"
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "current"
    t.integer  "number"
  end

  create_table "stat_lines", :force => true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.float    "points"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "team_id"
    t.float    "fgm"
    t.float    "fga"
    t.float    "fgpct"
    t.float    "threem"
    t.float    "threea"
    t.float    "threepct"
    t.float    "ftm"
    t.float    "fta"
    t.float    "ftpct"
    t.float    "orb"
    t.float    "drb"
    t.float    "trb"
    t.float    "ast"
    t.float    "stl"
    t.float    "blk"
    t.float    "fl"
    t.float    "to"
    t.boolean  "dnp"
    t.float    "twom"
    t.float    "twoa"
    t.float    "twopct"
    t.integer  "jersey_number"
    t.boolean  "double_double"
  end

  add_index "stat_lines", ["player_id"], :name => "index_stat_lines_on_player_id"
  add_index "stat_lines", ["team_id"], :name => "index_stat_lines_on_team_id"

  create_table "team_spots", :force => true do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "division_id"
    t.integer  "league_id"
    t.string   "team_photo_url"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "points_for"
    t.integer  "points_against"
    t.string   "streak"
  end

  add_index "team_spots", ["season_id"], :name => "index_team_spots_on_season_id"
  add_index "team_spots", ["team_id"], :name => "index_team_spots_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "abbreviation"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
