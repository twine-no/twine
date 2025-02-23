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

ActiveRecord::Schema[8.0].define(version: 2025_02_21_151845) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "platform_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_id"], name: "index_groups_on_platform_id"
  end

  create_table "groups_memberships", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "membership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "membership_id"], name: "index_groups_memberships_on_group_id_and_membership_id", unique: true
    t.index ["group_id"], name: "index_groups_memberships_on_group_id"
    t.index ["membership_id"], name: "index_groups_memberships_on_membership_id"
  end

  create_table "invites", force: :cascade do |t|
    t.integer "meeting_id", null: false
    t.integer "membership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid", null: false
    t.index ["guid"], name: "index_invites_on_guid", unique: true
    t.index ["meeting_id", "membership_id"], name: "index_invites_on_meeting_id_and_membership_id", unique: true
    t.index ["meeting_id"], name: "index_invites_on_meeting_id"
    t.index ["membership_id"], name: "index_invites_on_membership_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.integer "platform_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
    t.index ["platform_id"], name: "index_links_on_platform_id"
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
    t.datetime "happens_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.string "guid"
    t.boolean "open", default: false, null: false
    t.datetime "happens_at_updated_at"
    t.datetime "location_updated_at"
    t.datetime "last_communication_at"
    t.index ["guid"], name: "index_meetings_on_guid", unique: true
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.string "shortname"
    t.boolean "listed"
    t.string "tagline"
    t.string "category", default: "unorganised", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shortname"], name: "index_platforms_on_shortname", unique: true
  end

  create_table "rsvps", force: :cascade do |t|
    t.integer "invite_id"
    t.string "answer", default: "unanswered", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meeting_id", null: false
    t.string "email"
    t.string "guid", null: false
    t.string "full_name"
    t.datetime "confirmation_sent_at"
    t.index ["answer"], name: "index_rsvps_on_answer"
    t.index ["guid"], name: "index_rsvps_on_guid", unique: true
    t.index ["invite_id"], name: "index_rsvps_on_invite_id"
    t.index ["meeting_id"], name: "index_rsvps_on_meeting_id"
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
    t.string "template", default: "custom", null: false
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

  create_table "surveys_alternatives_responses", id: false, force: :cascade do |t|
    t.integer "response_id", null: false
    t.integer "alternative_id", null: false
    t.index ["alternative_id"], name: "index_surveys_alternatives_responses_on_alternative_id"
    t.index ["response_id", "alternative_id"], name: "index_surveys_alternatives_responses", unique: true
    t.index ["response_id"], name: "index_surveys_alternatives_responses_on_response_id"
  end

  create_table "surveys_questions", force: :cascade do |t|
    t.integer "survey_id", null: false
    t.string "title"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_surveys_questions_on_survey_id"
  end

  create_table "surveys_responses", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rsvp_id", null: false
    t.index ["question_id"], name: "index_surveys_responses_on_question_id"
    t.index ["rsvp_id"], name: "index_surveys_responses_on_rsvp_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "invites", "meetings"
  add_foreign_key "invites", "memberships"
  add_foreign_key "meetings", "platforms"
  add_foreign_key "memberships", "platforms"
  add_foreign_key "memberships", "users"
  add_foreign_key "rsvps", "invites"
  add_foreign_key "sessions", "platforms"
  add_foreign_key "sessions", "users"
  add_foreign_key "surveys_alternatives_responses", "surveys_alternatives", column: "alternative_id"
  add_foreign_key "surveys_alternatives_responses", "surveys_responses", column: "response_id"
end
