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

ActiveRecord::Schema.define(version: 20180707203419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "avatars", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "avatars", ["user_id"], name: "index_avatars_on_user_id", using: :btree

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "bookmarker_id", null: false
    t.integer  "bookmarked_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "bookmarks", ["bookmarked_id"], name: "index_bookmarks_on_bookmarked_id", using: :btree
  add_index "bookmarks", ["bookmarker_id", "bookmarked_id"], name: "index_bookmarks_on_bookmarker_id_and_bookmarked_id", unique: true, using: :btree
  add_index "bookmarks", ["bookmarker_id"], name: "index_bookmarks_on_bookmarker_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id",    null: false
    t.integer  "recipient_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id", using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "email_preferences", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status",                default: 0,    null: false
    t.boolean  "receive_notifications", default: true, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "email_preferences", ["user_id"], name: "index_email_preferences_on_user_id", unique: true, using: :btree

  create_table "interests", force: :cascade do |t|
    t.integer  "liker_id",                   null: false
    t.integer  "liked_id",                   null: false
    t.boolean  "rejected",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "interests", ["liked_id"], name: "index_interests_on_liked_id", using: :btree
  add_index "interests", ["liker_id", "liked_id"], name: "index_interests_on_liker_id_and_liked_id", unique: true, using: :btree
  add_index "interests", ["liker_id"], name: "index_interests_on_liker_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "body",            limit: 1000,                 null: false
    t.integer  "recipient_id",                                 null: false
    t.integer  "conversation_id",                              null: false
    t.boolean  "read",                         default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "sender_id",                                    null: false
    t.inet     "ip",                                           null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "phone_verifications", force: :cascade do |t|
    t.integer  "user_id",                                 null: false
    t.inet     "ip",                                      null: false
    t.string   "phone_number", limit: 30,                 null: false
    t.string   "session_id",   limit: 50
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "code",         limit: 10,                 null: false
    t.boolean  "verified",                default: false, null: false
    t.integer  "tries",        limit: 2,  default: 1,     null: false
  end

  add_index "phone_verifications", ["user_id"], name: "index_phone_verifications_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.inet     "ip",                     null: false
    t.text     "image_data"
    t.string   "caption",    limit: 500
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "profile_visits", force: :cascade do |t|
    t.integer  "visitor_id", null: false
    t.integer  "visited_id", null: false
    t.integer  "visits",     null: false
    t.date     "date",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profile_visits", ["visited_id"], name: "index_profile_visits_on_visited_id", using: :btree
  add_index "profile_visits", ["visitor_id", "visited_id", "date"], name: "index_profile_visits_on_visitor_id_and_visited_id_and_date", unique: true, using: :btree
  add_index "profile_visits", ["visitor_id"], name: "index_profile_visits_on_visitor_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "about",      limit: 1500
    t.integer  "user_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "occupation", limit: 1500
    t.string   "preference", limit: 1500
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", unique: true, using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "reporter_id",                              null: false
    t.integer  "reported_id",                              null: false
    t.integer  "reason",      limit: 2,                    null: false
    t.boolean  "resolved",                 default: false, null: false
    t.string   "description", limit: 1000
    t.string   "resolution",  limit: 1000
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "gender",           limit: 1,              null: false
    t.date     "birthdate",                               null: false
    t.integer  "religion",         limit: 2,              null: false
    t.string   "language",         limit: 3,              null: false
    t.string   "country",          limit: 2,              null: false
    t.string   "username",         limit: 30,             null: false
    t.string   "email",            limit: 60,             null: false
    t.string   "password_digest",  limit: 60,             null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "photo_visibility", limit: 2,  default: 1, null: false
    t.integer  "height",           limit: 2,              null: false
    t.integer  "status",           limit: 2,              null: false
    t.string   "sect",             limit: 5
    t.integer  "account_status",   limit: 2,  default: 0, null: false
    t.inet     "ip",                                      null: false
    t.integer  "income"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "avatars", "users"
  add_foreign_key "bookmarks", "users", column: "bookmarked_id"
  add_foreign_key "bookmarks", "users", column: "bookmarker_id"
  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "email_preferences", "users"
  add_foreign_key "interests", "users", column: "liked_id"
  add_foreign_key "interests", "users", column: "liker_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "phone_verifications", "users"
  add_foreign_key "photos", "users"
  add_foreign_key "profile_visits", "users", column: "visited_id"
  add_foreign_key "profile_visits", "users", column: "visitor_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "reports", "users", column: "reported_id"
  add_foreign_key "reports", "users", column: "reporter_id"
end
