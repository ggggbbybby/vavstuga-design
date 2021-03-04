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

ActiveRecord::Schema.define(version: 20210304004517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "patterns", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "yarn_id"
    t.string "name"
    t.json "stripes"
    t.json "default_colors"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "vavstuga_product_url"
    t.string "vavstuga_category_url"
    t.string "vavstuga_category_name"
    t.index ["user_id"], name: "index_patterns_on_user_id"
    t.index ["yarn_id"], name: "index_patterns_on_yarn_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "yarns", force: :cascade do |t|
    t.string "name"
    t.string "size"
    t.string "slug"
    t.json "colors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
