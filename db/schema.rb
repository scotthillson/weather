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

ActiveRecord::Schema.define(version: 20140707222947) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "locations", force: true do |t|
    t.string   "icao"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: true do |t|
    t.string   "action"
    t.string   "note"
    t.string   "run"
    t.string   "email"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  create_table "points", force: true do |t|
    t.datetime "time"
    t.integer  "high"
    t.integer  "low"
    t.decimal  "rain"
    t.integer  "cloud"
    t.integer  "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", force: true do |t|
    t.string   "run"
    t.string   "location"
    t.string   "model"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.string   "email"
    t.string   "frequency"
    t.boolean  "rain"
    t.boolean  "high"
    t.boolean  "low"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temperatures", force: true do |t|
    t.integer  "temperature"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "location"
    t.string   "name"
    t.integer  "elevation"
    t.decimal  "precipitation"
    t.decimal  "altimiter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
