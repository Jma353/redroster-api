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

ActiveRecord::Schema.define(version: 20160329233100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_reviews", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "courses", id: false, force: :cascade do |t|
    t.string   "term"
    t.string   "subject"
    t.integer  "number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "course_id"
    t.integer  "master_course_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.boolean  "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_courses", force: :cascade do |t|
    t.string   "subject"
    t.integer  "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_elements", primary_key: "schedule_id", force: :cascade do |t|
    t.integer  "section_num", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "collision"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "term"
  end

  create_table "sections", primary_key: "section_num", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "course_id"
    t.string   "section_type"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "day_pattern"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "google_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
