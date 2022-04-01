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

ActiveRecord::Schema[7.0].define(version: 2022_02_04_012308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_teams", force: :cascade do |t|
    t.integer "match_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "team_users", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.integer "score"
    t.integer "tournament_id"
    t.boolean "work_team?"
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
    t.integer "team_size"
    t.boolean "configured", default: false
    t.string "players", default: [], array: true
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
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
