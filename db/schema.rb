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

ActiveRecord::Schema[8.0].define(version: 2025_01_01_211641) do
  create_table "invites", force: :cascade do |t|
    t.integer "meeting_id", null: false
    t.integer "membership_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id", "membership_id"], name: "index_invites_on_meeting_id_and_membership_id", unique: true
    t.index ["meeting_id"], name: "index_invites_on_meeting_id"
    t.index ["membership_id"], name: "index_invites_on_membership_id"
  end

  create_table "meeting_log_entries", force: :cascade do |t|
    t.datetime "happened_at", null: false
    t.string "category", null: false
    t.integer "meeting_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_meeting_log_entries_on_meeting_id"
    t.index ["user_id"], name: "index_meeting_log_entries_on_user_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.integer "platform_id", null: false
    t.string "title", null: false
    t.datetime "scheduled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.text "description"
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

  create_table "messages", force: :cascade do |t|
    t.string "messageable_type", null: false
    t.integer "messageable_id", null: false
    t.string "category", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category", default: 0, null: false
  end

  create_table "rsvps", force: :cascade do |t|
    t.integer "invite_id", null: false
    t.string "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer"], name: "index_rsvps_on_answer"
    t.index ["invite_id"], name: "index_rsvps_on_invite_id"
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

  create_table "surveys", force: :cascade do |t|
    t.integer "meeting_id", null: false
    t.string "guid"
    t.boolean "open", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_surveys_on_guid", unique: true
    t.index ["meeting_id"], name: "index_surveys_on_meeting_id"
  end

  create_table "surveys_alternatives", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_surveys_alternatives_on_question_id"
  end

  create_table "surveys_answers", force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "alternative_id"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_surveys_answers_on_alternative_id"
    t.index ["question_id"], name: "index_surveys_answers_on_question_id"
  end

  create_table "surveys_questions", force: :cascade do |t|
    t.integer "survey_id", null: false
    t.string "title"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_surveys_questions_on_survey_id"
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

  add_foreign_key "invites", "meetings"
  add_foreign_key "invites", "memberships"
  add_foreign_key "meetings", "platforms"
  add_foreign_key "memberships", "platforms"
  add_foreign_key "memberships", "users"
  add_foreign_key "rsvps", "invites"
  add_foreign_key "sessions", "platforms"
  add_foreign_key "sessions", "users"
end
