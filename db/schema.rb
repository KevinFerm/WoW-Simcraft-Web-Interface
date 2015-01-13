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

ActiveRecord::Schema.define(version: 20150107120435) do

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.string   "region",            default: "eu"
    t.string   "realm"
    t.integer  "gender"
    t.string   "thumbnail"
    t.string   "calcClass"
    t.integer  "charClass"
    t.integer  "race"
    t.integer  "level"
    t.integer  "achievementPoints"
    t.string   "items"
    t.string   "stats"
    t.string   "hunterPets"
    t.string   "professions"
    t.string   "talents"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "characters", ["name", "realm", "region"], name: "index_characters_on_name_and_realm_and_region", unique: true

end
