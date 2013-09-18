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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121031133427) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "areas", :force => true do |t|
    t.string "name", :null => false
    t.string "code", :null => false
  end

  add_index "areas", ["name"], :name => "index_areas_on_name"

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "bookmarks", ["bookmarkable_id"], :name => "index_bookmarks_on_bookmarkable_id"
  add_index "bookmarks", ["bookmarkable_type"], :name => "index_bookmarks_on_bookmarkable_type"
  add_index "bookmarks", ["user_id"], :name => "index_bookmarks_on_user_id"

  create_table "comments", :force => true do |t|
    t.text     "content",          :limit => 255, :null => false
    t.integer  "user_id",                         :null => false
    t.integer  "parent_id",        :limit => 8
    t.string   "reply_title"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "place_id",    :null => false
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "description"
  end

  create_table "large_areas", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.integer "prefecture_id"
  end

  add_index "large_areas", ["name"], :name => "index_large_areas_on_name"

  create_table "places", :force => true do |t|
    t.string  "name",          :null => false
    t.string  "image"
    t.text    "introduction"
    t.integer "area_id",       :null => false
    t.string  "code",          :null => false
    t.integer "large_area_id", :null => false
  end

  add_index "places", ["area_id"], :name => "index_places_on_area_id"
  add_index "places", ["name"], :name => "index_places_on_name"

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.integer  "place_id"
    t.integer  "spot_id"
    t.decimal  "lat",         :precision => 18, :scale => 12
    t.decimal  "lng",         :precision => 18, :scale => 12
    t.string   "image"
    t.text     "description"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "video"
    t.string   "type"
  end

  add_index "posts", ["place_id"], :name => "index_posts_on_place_id"
  add_index "posts", ["spot_id"], :name => "index_posts_on_spot_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "prefectures", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.integer "area_id"
  end

  add_index "prefectures", ["name"], :name => "index_prefectures_on_name"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "spots", :force => true do |t|
    t.integer "place_id",                                 :null => false
    t.string  "name"
    t.string  "address"
    t.string  "image"
    t.decimal "lat",      :precision => 18, :scale => 12
    t.decimal "lng",      :precision => 18, :scale => 12
  end

  add_index "spots", ["address"], :name => "index_spots_on_address"
  add_index "spots", ["name"], :name => "index_spots_on_name"
  add_index "spots", ["place_id"], :name => "index_spots_on_place_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                                    :null => false
    t.string   "facebook_id",                                             :null => false
    t.string   "facebook_access_token",                                   :null => false
    t.string   "access_token"
    t.string   "avatar",                :limit => 512
    t.boolean  "deleted",                              :default => false, :null => false
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "users", ["access_token"], :name => "index_users_on_access_token", :unique => true
  add_index "users", ["facebook_access_token"], :name => "index_users_on_facebook_access_token", :unique => true
  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"

end
