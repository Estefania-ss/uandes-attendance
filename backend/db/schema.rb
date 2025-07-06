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

ActiveRecord::Schema[8.0].define(version: 2025_07_06_213845) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applicants", force: :cascade do |t|
    t.string "name"
    t.string "rut"
    t.string "school"
    t.string "comuna"
    t.string "career_interest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "candidate_id"
    t.string "last_name"
    t.string "graduation_year"
    t.string "graduation_status"
    t.string "phone"
    t.string "career_interest_2"
    t.string "region"
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.bigint "event_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_attendances_on_applicant_id"
    t.index ["event_id"], name: "index_attendances_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "event_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaign_id"
  end

  create_table "room_assignments", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.bigint "room_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_room_assignments_on_applicant_id"
    t.index ["event_id"], name: "index_room_assignments_on_event_id"
    t.index ["room_id"], name: "index_room_assignments_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.string "building"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_rooms_on_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendances", "applicants"
  add_foreign_key "attendances", "events"
  add_foreign_key "room_assignments", "applicants"
  add_foreign_key "room_assignments", "events"
  add_foreign_key "room_assignments", "rooms"
  add_foreign_key "rooms", "events"
end
