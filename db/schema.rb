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

ActiveRecord::Schema.define(version: 20160429204331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_reviews", force: :cascade do |t|
    t.integer  "master_course_id"
    t.integer  "user_id"
    t.string   "term"
    t.integer  "lecture_score"
    t.integer  "office_hours_score"
    t.integer  "difficulty_score"
    t.integer  "material_score"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "course_reviews", ["master_course_id"], name: "index_course_reviews_on_master_course_id", using: :btree
  add_index "course_reviews", ["user_id"], name: "index_course_reviews_on_user_id", using: :btree

  create_table "courses", primary_key: "course_id", force: :cascade do |t|
    t.integer  "master_course_id"
    t.string   "term"
    t.string   "subject"
    t.integer  "number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "courses", ["master_course_id"], name: "index_courses_on_master_course_id", using: :btree

  create_table "followings", force: :cascade do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.boolean  "is_active"
    t.integer  "following_score"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "followings", ["user1_id"], name: "index_followings_on_user1_id", using: :btree
  add_index "followings", ["user2_id"], name: "index_followings_on_user2_id", using: :btree

  create_table "master_courses", force: :cascade do |t|
    t.string   "subject"
    t.integer  "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_elements", primary_key: "schedule_id", force: :cascade do |t|
    t.integer  "section_num", null: false
    t.boolean  "collision"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "schedule_elements", ["schedule_id"], name: "index_schedule_elements_on_schedule_id", using: :btree
  add_index "schedule_elements", ["section_num"], name: "index_schedule_elements_on_section_num", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "sections", primary_key: "section_num", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "section_type"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "day_pattern"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "google_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
