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

ActiveRecord::Schema.define(:version => 20130930155347) do

  create_table "date_ranges", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.boolean  "playoffs"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "season_id"
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
  end

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
    t.string   "about"
    t.string   "day_job"
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
  end

  create_table "team_spots", :force => true do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "division_id"
    t.integer  "league_id"
  end

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
