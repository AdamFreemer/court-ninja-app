# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_05_20_212238) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_tournament_teams", force: :cascade do |t|
    t.bigint "match_id"
    t.bigint "tournament_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_tournament_teams_on_match_id"
    t.index ["tournament_team_id"], name: "index_match_tournament_teams_on_tournament_team_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "zip"
    t.integer "number"
    t.integer "court"
    t.integer "round"
    t.integer "tournament_id"
    t.integer "ghost_players", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournament_team_users", force: :cascade do |t|
    t.bigint "tournament_team_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_team_id"], name: "index_tournament_team_users_on_tournament_team_id"
    t.index ["user_id"], name: "index_tournament_team_users_on_user_id"
  end

  create_table "tournament_teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tournament_id"
    t.integer "number"
    t.integer "score"
    t.boolean "work_team"
    t.index ["tournament_id"], name: "index_tournament_teams_on_tournament_id"
  end

  create_table "tournament_users", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "date"
    t.integer "courts"
    t.string "court_1_name"
    t.string "court_2_name"
    t.string "court_3_name"
    t.string "court_4_name"
    t.string "court_5_name"
    t.string "court_6_name"
    t.integer "rounds"
    t.integer "team_size"
    t.integer "work_group"
    t.integer "rounds_configured", default: [], array: true
    t.integer "rounds_finalized", default: [], array: true
    t.integer "players", default: [], array: true
    t.string "court_names", default: [], array: true
    t.decimal "tournament_time", precision: 5, scale: 1
    t.decimal "break_time", precision: 5, scale: 1
    t.integer "timer_time", default: 0
    t.string "timer_state", default: "initial"
    t.string "timer_mode", default: "break"
    t.integer "current_set", default: 1
    t.integer "current_round", default: 1
    t.boolean "tournament_completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traits", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_objective?"
    t.boolean "is_subjective?"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_scores", force: :cascade do |t|
    t.integer "user_id"
    t.integer "match_id"
    t.integer "team_id"
    t.integer "tournament_id"
    t.integer "score"
    t.integer "court"
    t.integer "round"
    t.integer "win"
    t.integer "loss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_traits", force: :cascade do |t|
    t.integer "user_id"
    t.integer "trait_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone_number"
    t.string "jersey_number"
    t.string "position"
    t.string "gender"
    t.string "contact_1_name"
    t.string "contact_1_phone"
    t.string "contact_1_address"
    t.string "contact_2_name"
    t.string "contact_2_phone"
    t.string "contact_2_address"
    t.boolean "is_ghost_player", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "match_tournament_teams", "matches"
  add_foreign_key "match_tournament_teams", "tournament_teams"
  add_foreign_key "tournament_team_users", "tournament_teams"
  add_foreign_key "tournament_team_users", "users"
  add_foreign_key "tournament_teams", "tournaments"
end
