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

ActiveRecord::Schema.define(version: 2018_11_19_165251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "slate_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slate_id"], name: "index_cards_on_slate_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "description"
    t.integer "status", default: 0
    t.jsonb "data", default: {}
    t.bigint "slate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slate_id"], name: "index_events_on_slate_id"
  end

  create_table "picks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "selection_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_picks_on_event_id"
    t.index ["selection_id"], name: "index_picks_on_selection_id"
    t.index ["user_id"], name: "index_picks_on_user_id"
  end

  create_table "selections", force: :cascade do |t|
    t.string "description"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_selections_on_event_id"
  end

  create_table "slates", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "start_time"
    t.string "type"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.jsonb "data", default: {}
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cards", "slates"
  add_foreign_key "cards", "users"
  add_foreign_key "events", "slates"
  add_foreign_key "picks", "events"
  add_foreign_key "picks", "selections"
  add_foreign_key "picks", "users"
  add_foreign_key "selections", "events"
  add_foreign_key "sweeps", "users"
end
