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

ActiveRecord::Schema[7.0].define(version: 2023_01_18_191413) do
  create_table "articles", force: :cascade do |t|
    t.string "description"
    t.string "link"
    t.datetime "published_date"
    t.string "publisher"
    t.string "title"
    t.boolean "stale"
    t.integer "source_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "media_url"
    t.index ["source_id"], name: "index_articles_on_source_id"
    t.index ["stale"], name: "index_articles_on_stale"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "language"
    t.datetime "published_date"
    t.string "heading"
    t.text "content"
    t.boolean "active"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "space_id", null: false
    t.string "html_file_name"
    t.index ["space_id"], name: "index_blogs_on_space_id"
    t.index ["user_id", "html_file_name"], name: "index_blogs_on_user_id_and_html_file_name", unique: true
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "favourites", force: :cascade do |t|
    t.string "description"
    t.string "link"
    t.datetime "published_date"
    t.string "publisher"
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "tags_json"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "tags"
    t.index ["name", "user_id"], name: "index_groups_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "highlights", force: :cascade do |t|
    t.string "keyword"
    t.string "colour"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_highlights_on_user_id"
  end

  create_table "histories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "user_id"
    t.boolean "stale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "user_id"], name: "index_histories_on_article_id_and_user_id", unique: true
    t.index ["article_id"], name: "index_histories_on_article_id"
    t.index ["stale"], name: "index_histories_on_stale"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "article_id"
    t.integer "highlight_id"
    t.integer "user_id"
    t.boolean "stale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_notifications_on_article_id"
    t.index ["highlight_id"], name: "index_notifications_on_highlight_id"
    t.index ["stale"], name: "index_notifications_on_stale"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "description", limit: 512
    t.string "icon"
    t.string "language"
    t.string "name", null: false
    t.datetime "timestamp"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false
    t.json "categories"
    t.boolean "published"
    t.boolean "restricted", default: true, null: false
    t.integer "creator_id"
    t.integer "counter"
    t.integer "visibility", default: 1
    t.index ["creator_id"], name: "index_sources_on_creator_id"
    t.index ["url"], name: "index_sources_on_url", unique: true
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["name"], name: "index_spaces_on_name", unique: true
    t.index ["path"], name: "index_spaces_on_path", unique: true
    t.index ["user_id"], name: "index_spaces_on_user_id"
  end

  create_table "streams", force: :cascade do |t|
    t.string "name"
    t.integer "group_id"
    t.integer "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["group_id"], name: "index_streams_on_group_id"
    t.index ["name", "group_id", "source_id"], name: "index_streams_on_name_and_group_id_and_source_id", unique: true
    t.index ["source_id"], name: "index_streams_on_source_id"
    t.index ["user_id"], name: "index_streams_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "favourite_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favourite_id"], name: "index_taggings_on_favourite_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "colour"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "throttles", force: :cascade do |t|
    t.integer "count"
    t.string "remote_ip"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sysadmin"
    t.json "settings"
    t.datetime "deactivated_at"
    t.datetime "last_logged_in"
    t.date "subscription_date"
    t.date "subscription_end_date"
    t.index ["deactivated_at"], name: "index_users_on_deactivated_at"
    t.index ["email"], name: "unique_emails", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "blogs", "spaces"
  add_foreign_key "favourites", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "spaces", "users"
  add_foreign_key "streams", "groups"
  add_foreign_key "streams", "sources"
end
