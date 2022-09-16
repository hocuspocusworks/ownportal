# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_16_193604) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favourites", force: :cascade do |t|
    t.string "description"
    t.string "link"
    t.datetime "published_date"
    t.string "publisher"
    t.string "title"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_groups_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "description"
    t.string "icon"
    t.string "language"
    t.string "name", null: false
    t.datetime "timestamp"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_sources_on_url", unique: true
  end

  create_table "streams", force: :cascade do |t|
    t.string "name"
    t.bigint "group_id"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_streams_on_group_id"
    t.index ["name", "group_id", "source_id"], name: "index_streams_on_name_and_group_id_and_source_id", unique: true
    t.index ["source_id"], name: "index_streams_on_source_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "token"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "unique_emails", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "favourites", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "streams", "groups"
  add_foreign_key "streams", "sources"
end
