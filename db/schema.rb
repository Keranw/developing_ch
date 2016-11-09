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

ActiveRecord::Schema.define(version: 20161020005026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_users", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "account_name"
    t.string   "password"
    t.string   "email",                      default: ""
    t.string   "account_type"
    t.string   "token"
    t.string   "name",                       default: ""
    t.date     "birthday"
    t.string   "sex",                        default: ""
    t.string   "avatar",                     default: ""
    t.string   "education",                  default: ""
    t.string   "school",                     default: ""
    t.string   "language",                   default: ""
    t.string   "profession",                 default: ""
    t.string   "hobby",                      default: ""
    t.string   "signature",                  default: ""
    t.boolean  "is_vip",                     default: false
    t.date     "vip_purchase_date"
    t.boolean  "activated",                  default: false
    t.string   "activation_token"
    t.string   "reset_token"
    t.datetime "reset_token_generated_time"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["user_id"], name: "index_app_users_on_user_id", unique: true, using: :btree
  end

end
