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

ActiveRecord::Schema[8.0].define(version: 2024_12_21_141912) do
  create_table "meetings", force: :cascade do |t|
    t.integer "platform_id", null: false
    t.string "title", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_id"], name: "index_meetings_on_platform_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "platform_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_id", "user_id"], name: "index_memberships_on_platform_id_and_user_id", unique: true
    t.index ["platform_id"], name: "index_memberships_on_platform_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category", default: 0, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "platform_id"
    t.index ["platform_id"], name: "index_sessions_on_platform_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "registered_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "meetings", "platforms"
  add_foreign_key "memberships", "platforms"
  add_foreign_key "memberships", "users"
  add_foreign_key "sessions", "platforms"
  add_foreign_key "sessions", "users"
end
