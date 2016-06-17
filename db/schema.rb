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

ActiveRecord::Schema.define(version: 20160623213452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "slack_username",                                          null: false
    t.date     "started_on",                                              null: false
    t.string   "time_zone",        default: "Eastern Time (US & Canada)", null: false
    t.datetime "deleted_at"
    t.string   "slack_channel_id"
    t.string   "slack_user_id"
  end

  add_index "employees", ["deleted_at"], name: "index_employees_on_deleted_at", using: :btree
  add_index "employees", ["slack_user_id"], name: "index_employees_on_slack_user_id", using: :btree

  create_table "scheduled_messages", force: :cascade do |t|
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "title",                                              null: false
    t.text     "body",                                               null: false
    t.integer  "days_after_start"
    t.time     "time_of_day",        default: '2000-01-01 12:00:00', null: false
    t.datetime "deleted_at"
    t.date     "end_date"
    t.integer  "message_time_frame", default: 0
  end

  add_index "scheduled_messages", ["deleted_at"], name: "index_scheduled_messages_on_deleted_at", using: :btree

  create_table "sent_scheduled_messages", force: :cascade do |t|
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "employee_id",                                          null: false
    t.string   "error_message",        default: "",                    null: false
    t.text     "message_body",                                         null: false
    t.integer  "scheduled_message_id",                                 null: false
    t.date     "sent_on",                                              null: false
    t.time     "sent_at",              default: '2000-01-01 12:00:00', null: false
    t.datetime "deleted_at"
  end

  add_index "sent_scheduled_messages", ["deleted_at"], name: "index_sent_scheduled_messages_on_deleted_at", using: :btree
  add_index "sent_scheduled_messages", ["employee_id", "scheduled_message_id"], name: "by_employee_scheduled_message", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "email",                      null: false
    t.boolean  "admin",      default: false
  end

end
