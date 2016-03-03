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

ActiveRecord::Schema.define(version: 20160303164801) do

  create_table "images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "img_src"
    t.integer  "position"
    t.boolean  "main_image?"
    t.boolean  "flagged?"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "images", ["user_id"], name: "index_images_on_user_id"

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "likee_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "match",            default: false
    t.datetime "match_time"
    t.integer  "likee_seen_count", default: 0
  end

  add_index "likes", ["likee_id"], name: "index_likes_on_likee_id"
  add_index "likes", ["user_id"], name: "index_likes_on_user_id"

  create_table "matches", force: :cascade do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "user_1_seen", default: false
    t.boolean  "user_2_seen", default: false
    t.integer  "pitcher_id"
    t.boolean  "pitch_seen",  default: false
    t.boolean  "locked",      default: true
  end

  add_index "matches", ["pitcher_id"], name: "index_matches_on_pitcher_id"
  add_index "matches", ["user_1_id"], name: "index_matches_on_user_1_id"
  add_index "matches", ["user_2_id"], name: "index_matches_on_user_2_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.integer  "gender"
    t.string   "password"
    t.string   "university"
    t.string   "job_title"
    t.string   "company_name"
    t.string   "blurb"
    t.date     "birthday"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "lat"
    t.float    "lng"
    t.integer  "interested_in"
  end

end
