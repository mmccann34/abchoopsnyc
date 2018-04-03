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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180403214037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abc_plus_scores", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.float    "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "career_highs", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "description", limit: 255
    t.float    "value"
    t.string   "game",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "stat_type",   limit: 255
    t.integer  "game_id"
  end

  add_index "career_highs", ["player_id"], name: "index_career_highs_on_player_id", using: :btree

  create_table "date_ranges", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name",       limit: 255
    t.boolean  "playoffs"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "season_id"
    t.string   "short_name", limit: 255
    t.integer  "league_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "divisions", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
    t.integer  "season_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "season_id"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
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
    t.string   "playoff_round",       limit: 255
    t.text     "photo_urls"
  end

  add_index "games", ["season_id"], name: "index_games_on_season_id", using: :btree

  create_table "leagues", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "short_name", limit: 255
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "map_url"
  end

  create_table "player_stats", force: :cascade do |t|
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
    t.string   "stat_type",     limit: 255
    t.string   "split_name",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "season_number"
    t.integer  "league_id"
    t.integer  "double_double"
  end

  add_index "player_stats", ["player_id", "stat_type", "season_id"], name: "index_player_stats_on_player_id_and_stat_type_and_season_id", using: :btree
  add_index "player_stats", ["stat_type", "season_id"], name: "index_player_stats_on_stat_type_and_season_id", using: :btree
  add_index "player_stats", ["team_id", "stat_type", "season_id"], name: "index_player_stats_on_team_id_and_stat_type_and_season_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "first_name",                        limit: 255
    t.string   "last_name",                         limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "height",                            limit: 255
    t.integer  "weight"
    t.integer  "age"
    t.string   "key",                               limit: 255
    t.string   "profile_pic_file_name",             limit: 255
    t.string   "profile_pic_content_type",          limit: 255
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.integer  "team_id"
    t.integer  "number"
    t.integer  "height_feet"
    t.integer  "height_inches"
    t.string   "school",                            limit: 255
    t.string   "position",                          limit: 255
    t.string   "hometown",                          limit: 255
    t.text     "about"
    t.string   "day_job",                           limit: 255
    t.date     "birthday"
    t.string   "profile_pic_url",                   limit: 255
    t.string   "profile_pic_flickr_url",            limit: 255
    t.text     "social_media_urls"
    t.string   "profile_pic_thumb_url",             limit: 255
    t.string   "display_name",                      limit: 255
    t.string   "slug",                              limit: 255
    t.integer  "main_team_id"
    t.integer  "last_number"
    t.string   "league_love",                       limit: 255
    t.string   "little_known_fact",                 limit: 255
    t.string   "did_you_know",                      limit: 255
    t.string   "one_last_thing",                    limit: 255
    t.integer  "needs_to_calc_stats_for_season_id"
    t.string   "email"
  end

  add_index "players", ["slug"], name: "index_players_on_slug", using: :btree

  create_table "roster_spots", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "season_id"
    t.integer  "jersey_number"
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "key",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "current"
    t.integer  "number"
  end

  create_table "stat_lines", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.float    "points"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
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
    t.integer  "season_id"
    t.integer  "vs_team_id"
  end

  add_index "stat_lines", ["ast"], name: "index_stat_lines_on_ast", using: :btree
  add_index "stat_lines", ["blk"], name: "index_stat_lines_on_blk", using: :btree
  add_index "stat_lines", ["fgm"], name: "index_stat_lines_on_fgm", using: :btree
  add_index "stat_lines", ["ftm"], name: "index_stat_lines_on_ftm", using: :btree
  add_index "stat_lines", ["game_id"], name: "index_stat_lines_on_game_id", using: :btree
  add_index "stat_lines", ["player_id", "season_id"], name: "index_stat_lines_on_player_id_and_season_id", using: :btree
  add_index "stat_lines", ["points"], name: "index_stat_lines_on_points", using: :btree
  add_index "stat_lines", ["stl"], name: "index_stat_lines_on_stl", using: :btree
  add_index "stat_lines", ["team_id", "season_id"], name: "index_stat_lines_on_team_id_and_season_id", using: :btree
  add_index "stat_lines", ["threem"], name: "index_stat_lines_on_threem", using: :btree
  add_index "stat_lines", ["trb"], name: "index_stat_lines_on_trb", using: :btree

  create_table "team_spots", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "division_id"
    t.integer  "league_id"
    t.string   "team_photo_url", limit: 255
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "points_for"
    t.integer  "points_against"
    t.string   "streak",         limit: 255
    t.integer  "ties"
  end

  add_index "team_spots", ["season_id"], name: "index_team_spots_on_season_id", using: :btree
  add_index "team_spots", ["team_id"], name: "index_team_spots_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                              limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "abbreviation",                      limit: 255
    t.string   "slug",                              limit: 255
    t.integer  "needs_to_calc_stats_for_season_id"
  end

  add_index "teams", ["slug"], name: "index_teams_on_slug", using: :btree

  create_table "top_performer_points", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "top_performers", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.string   "name",           limit: 255
    t.string   "stat",           limit: 255
    t.integer  "performer_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "team_id"
  end

  add_index "top_performers", ["game_id"], name: "index_top_performers_on_game_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
