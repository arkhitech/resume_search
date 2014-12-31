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

ActiveRecord::Schema.define(version: 20141223062812) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.date     "published_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employer_histories", force: true do |t|
    t.string   "organization_name"
    t.integer  "resume_id"
    t.integer  "description_id"
    t.string   "description_type"
    t.string   "title"
    t.string   "country_code"
    t.string   "start_date"
    t.string   "end_date"
    t.string   "months_of_work"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employer_histories", ["description_id", "description_type"], name: "index_employer_histories_on_description_id_and_description_type", using: :btree
  add_index "employer_histories", ["resume_id"], name: "index_employer_histories_on_resume_id", using: :btree

  create_table "notes", force: true do |t|
    t.text     "summary"
    t.integer  "description_id"
    t.string   "description_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["description_id", "description_type"], name: "index_notes_on_description_id_and_description_type", using: :btree

  create_table "resumes", force: true do |t|
    t.string   "name"
    t.string   "telephone"
    t.string   "email"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
