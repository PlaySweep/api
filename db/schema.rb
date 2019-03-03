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

ActiveRecord::Schema.define(version: 2019_03_03_211930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "type", default: "Account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "tenant"
  end

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "slate_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slate_id"], name: "index_cards_on_slate_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "used", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "description"
    t.integer "status", default: 0
    t.jsonb "data", default: {}
    t.bigint "slate_id"
    t.string "type", default: "Event"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slate_id"], name: "index_events_on_slate_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id"
    t.string "image"
    t.string "type", default: "Owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data", default: {}
    t.index ["account_id"], name: "index_owners_on_account_id"
  end

  create_table "picks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "selection_id"
    t.bigint "event_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_picks_on_event_id"
    t.index ["selection_id"], name: "index_picks_on_selection_id"
    t.index ["user_id"], name: "index_picks_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "user_id"
    t.string "type", default: "Preference"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selections", force: :cascade do |t|
    t.string "description"
    t.bigint "event_id"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_selections_on_event_id"
  end

  create_table "slates", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "start_time"
    t.string "type", default: "Slate"
    t.integer "status", default: 0
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data", default: {}
    t.index ["owner_id"], name: "index_slates_on_owner_id"
  end

  create_table "sweeps", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "date"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sweeps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "facebook_uuid"
    t.string "first_name"
    t.string "last_name"
    t.string "handle"
    t.string "email"
    t.string "phone_number"
    t.string "avatar"
    t.string "gender"
    t.integer "timezone"
    t.string "type", default: "User"
    t.jsonb "data", default: {}
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
    t.string "locale"
    t.string "profile_pic"
    t.string "zipcode"
    t.date "dob"
  end

  add_foreign_key "cards", "slates"
  add_foreign_key "cards", "users"
  add_foreign_key "events", "slates"
  add_foreign_key "owners", "accounts"
  add_foreign_key "picks", "events"
  add_foreign_key "picks", "selections"
  add_foreign_key "picks", "users"
  add_foreign_key "selections", "events"
  add_foreign_key "slates", "owners"
  add_foreign_key "sweeps", "users"
end
