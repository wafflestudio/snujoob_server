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

ActiveRecord::Schema.define(version: 20150128172559) do

  create_table "subjects", force: true do |t|
    t.string   "subject_name"
    t.string   "subject_number"
    t.string   "lecture_number"
    t.string   "lecturer"
    t.integer  "capacity"
    t.integer  "enrolled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity_enrolled"
  end

  create_table "subjects_users", id: false, force: true do |t|
    t.integer "subject_id"
    t.integer "user_id"
  end

  add_index "subjects_users", ["subject_id"], name: "index_subjects_users_on_subject_id"
  add_index "subjects_users", ["user_id"], name: "index_subjects_users_on_user_id"

  create_table "users", force: true do |t|
    t.string   "student_number"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "device"
    t.string   "reg_id"
  end

end
