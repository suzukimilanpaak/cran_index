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

ActiveRecord::Schema.define(version: 20160420101721) do

  create_table "committers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "type",       limit: 50
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "committers_descriptions", force: :cascade do |t|
    t.integer  "committer_id",   limit: 4
    t.integer  "description_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "committers_descriptions", ["description_id", "committer_id"], name: "index_committers_descriptions_on_description_id_and_committer_id", using: :btree

  create_table "descriptions", force: :cascade do |t|
    t.integer  "package_id",   limit: 4
    t.string   "version",      limit: 255
    t.string   "title",        limit: 255
    t.text     "description",  limit: 65535
    t.datetime "published_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string   "name",                   limit: 150
    t.integer  "current_description_id", limit: 4
    t.string   "current_version",        limit: 20
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

end
