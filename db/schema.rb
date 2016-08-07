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

ActiveRecord::Schema.define(version: 20160807033349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beta_testers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_reviews", force: :cascade do |t|
    t.integer  "crse_id"
    t.integer  "user_id"
    t.string   "term"
    t.integer  "lecture_score"
    t.integer  "office_hours_score"
    t.integer  "difficulty_score"
    t.integer  "material_score"
    t.string   "feedback"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "course_reviews", ["user_id"], name: "index_course_reviews_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.integer  "crse_id"
    t.string   "term"
    t.string   "subject"
    t.integer  "catalog_number"
    t.integer  "course_offer_number"
    t.integer  "credits_maximum"
    t.integer  "credits_minimum"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "title"
  end

  create_table "following_requests", force: :cascade do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.integer  "sent_by_id"
    t.boolean  "is_pending"
    t.boolean  "is_accepted"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "following_requests", ["sent_by_id"], name: "index_following_requests_on_sent_by_id", using: :btree
  add_index "following_requests", ["user1_id"], name: "index_following_requests_on_user1_id", using: :btree
  add_index "following_requests", ["user2_id"], name: "index_following_requests_on_user2_id", using: :btree

  create_table "followings", force: :cascade do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.boolean  "u1_follows_u2"
    t.boolean  "u2_follows_u1"
    t.integer  "u1_popularity"
    t.integer  "u2_popularity"
    t.boolean  "is_active"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "followings", ["user1_id"], name: "index_followings_on_user1_id", using: :btree
  add_index "followings", ["user2_id"], name: "index_followings_on_user2_id", using: :btree

  create_table "schedule_elements", force: :cascade do |t|
    t.integer  "schedule_id"
    t.integer  "section_id"
    t.boolean  "collision"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "subject"
    t.integer  "catalog_number"
  end

  add_index "schedule_elements", ["schedule_id"], name: "index_schedule_elements_on_schedule_id", using: :btree
  add_index "schedule_elements", ["section_id"], name: "index_schedule_elements_on_section_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "term"
    t.string   "name"
    t.boolean  "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.integer  "section_num"
    t.integer  "course_id"
    t.string   "section_type"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "day_pattern"
    t.string   "class_number"
    t.string   "long_location"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "topic_description"
    t.integer  "enroll_group"
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "google_id"
    t.string   "email"
    t.string   "fname"
    t.string   "lname"
    t.string   "picture_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
