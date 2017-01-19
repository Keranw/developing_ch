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

ActiveRecord::Schema.define(version: 20170118001957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_users", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "account_name"
    t.string   "password"
    t.string   "account_type"
    t.string   "token"
    t.string   "device_token"
    t.string   "reset_token"
    t.datetime "reset_token_generated_time"
    t.string   "name",                       default: ""
    t.date     "birthday"
    t.integer  "sex"
    t.string   "avatar",                     default: ""
    t.string   "avatar_frame",               default: ""
    t.integer  "avatar_count",               default: 0
    t.integer  "not_interest"
    t.string   "email",                      default: ""
    t.string   "school",                     default: ""
    t.string   "language",                   default: ""
    t.string   "working_area",               default: ""
    t.integer  "hobby",                      default: [],                 array: true
    t.string   "signature",                  default: ""
    t.boolean  "is_vip",                     default: false
    t.date     "vip_purchase_date"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["user_id"], name: "index_app_users_on_user_id", unique: true, using: :btree
  end

  create_table "message_temps", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "msg_type"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pairing_infos", force: :cascade do |t|
    t.integer  "app_user_id"
    t.integer  "user_id"
    t.integer  "postcode"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "rest_five",   default: [],              array: true
    t.integer  "like",        default: 0
    t.integer  "dislike",     default: 0
    t.integer  "like_list",   default: [],              array: true
    t.integer  "met_me",      default: [],              array: true
    t.integer  "friend_list", default: [],              array: true
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
