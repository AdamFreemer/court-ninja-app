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

ActiveRecord::Schema[7.0].define(version: 2024_09_05_023215) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "coach_players_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_teams", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pending", default: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.index ["player_id"], name: "index_player_teams_on_player_id"
    t.index ["team_id"], name: "index_player_teams_on_team_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show_on_signup_form", default: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "invite_code"
    t.boolean "active", default: true
    t.bigint "coach_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_teams_on_coach_id"
  end

  create_table "tournament_set_tournament_teams", force: :cascade do |t|
    t.bigint "tournament_set_id"
    t.bigint "tournament_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_set_id"], name: "index_tournament_set_tournament_teams_on_tournament_set_id"
    t.index ["tournament_team_id"], name: "index_tournament_set_tournament_teams_on_tournament_team_id"
  end

  create_table "tournament_sets", force: :cascade do |t|
    t.bigint "tournament_id"
    t.string "zip"
    t.integer "number"
    t.integer "court"
    t.integer "round"
    t.integer "ghost_players", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_tournament_sets_on_tournament_id"
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
    t.integer "court"
    t.integer "round"
    t.index ["tournament_id"], name: "index_tournament_teams_on_tournament_id"
  end

  create_table "tournament_users", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_tournament_users_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_users_on_user_id"
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
    t.integer "current_round", default: 0
    t.boolean "tournament_completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "court_side_a_name"
    t.string "court_side_b_name"
    t.bigint "created_by_id"
    t.string "configuration"
    t.boolean "adhoc", default: false
    t.integer "match_time"
    t.integer "pre_match_time"
    t.json "admin_views", default: {}
    t.integer "admin_view_current"
    t.float "total_tournament_time"
    t.integer "matches_per_round"
    t.json "current_matches", default: {}
    t.integer "current_match", default: 1
    t.boolean "is_new", default: true
    t.integer "winner_id", default: 0
    t.bigint "base_team_id"
    t.string "teams", default: [], array: true
    t.index ["base_team_id"], name: "index_tournaments_on_base_team_id"
    t.index ["created_by_id"], name: "index_tournaments_on_created_by_id"
  end

  create_table "traits", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_objective?"
    t.boolean "is_subjective?"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_role_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status", default: "pending"
    t.bigint "processed_by_id"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processed_by_id"], name: "index_user_role_requests_on_processed_by_id"
    t.index ["user_id"], name: "index_user_role_requests_on_user_id"
  end

  create_table "user_role_requests_roles", id: false, force: :cascade do |t|
    t.bigint "user_role_request_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_user_role_requests_roles_on_role_id"
    t.index ["user_role_request_id", "role_id"], name: "index_user_role_requests_roles_on_user_role_request_and_role"
    t.index ["user_role_request_id"], name: "index_user_role_requests_roles_on_user_role_request_id"
  end

  create_table "user_scores", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tournament_set_id"
    t.bigint "tournament_team_id"
    t.bigint "tournament_id"
    t.integer "score"
    t.integer "court"
    t.integer "round"
    t.integer "win"
    t.integer "loss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_user_scores_on_tournament_id"
    t.index ["tournament_set_id"], name: "index_user_scores_on_tournament_set_id"
    t.index ["tournament_team_id"], name: "index_user_scores_on_tournament_team_id"
    t.index ["user_id"], name: "index_user_scores_on_user_id"
  end

  create_table "user_traits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "trait_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trait_id"], name: "index_user_traits_on_trait_id"
    t.index ["user_id"], name: "index_user_traits_on_user_id"
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
    t.boolean "is_player", default: false
    t.boolean "is_ghost_player", default: false
    t.boolean "is_admin", default: false
    t.boolean "is_coach", default: false
    t.boolean "is_one_off", default: false
    t.string "unlock_token"
    t.string "confirmation_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "coach_id"
    t.boolean "adhoc", default: false
    t.string "nick_name"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.date "date_of_birth"
    t.boolean "is_active", default: true
    t.boolean "is_on_leaderboard", default: true
    t.integer "team_id"
    t.index ["coach_id"], name: "index_users_on_coach_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "player_teams", "teams"
  add_foreign_key "player_teams", "users", column: "player_id"
  add_foreign_key "teams", "users", column: "coach_id"
  add_foreign_key "tournament_set_tournament_teams", "tournament_sets"
  add_foreign_key "tournament_set_tournament_teams", "tournament_teams"
  add_foreign_key "tournament_sets", "tournaments"
  add_foreign_key "tournament_team_users", "tournament_teams"
  add_foreign_key "tournament_team_users", "users"
  add_foreign_key "tournament_teams", "tournaments"
  add_foreign_key "tournament_users", "tournaments"
  add_foreign_key "tournament_users", "users"
  add_foreign_key "tournaments", "teams", column: "base_team_id"
  add_foreign_key "tournaments", "users", column: "created_by_id"
  add_foreign_key "user_role_requests", "users"
  add_foreign_key "user_role_requests", "users", column: "processed_by_id"
  add_foreign_key "user_scores", "tournament_sets"
  add_foreign_key "user_scores", "tournament_teams"
  add_foreign_key "user_scores", "tournaments"
  add_foreign_key "user_scores", "users"
  add_foreign_key "user_traits", "traits"
  add_foreign_key "user_traits", "users"
  add_foreign_key "users", "users", column: "coach_id"
end
