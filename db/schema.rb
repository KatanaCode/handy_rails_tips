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

ActiveRecord::Schema.define(:version => 20090513094924) do

  create_table "ads", :force => true do |t|
    t.string   "url"
    t.string   "company",    :limit => 50, :default => "", :null => false
    t.integer  "position",   :limit => 2,  :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ads", ["position"], :name => "index_ads_on_position"

  create_table "comments", :force => true do |t|
    t.text     "body",                                     :null => false
    t.string   "url",                      :default => "", :null => false
    t.string   "email",      :limit => 50, :default => "", :null => false
    t.string   "name",       :limit => 20, :default => "", :null => false
    t.integer  "tip_id",                   :default => 0,  :null => false
    t.integer  "state",      :limit => 1,  :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["tip_id"], :name => "index_comments_on_tip_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.integer  "tip_id",     :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.text     "message",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.text     "content",    :null => false
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "criterion",  :limit => 20, :default => "",    :null => false
    t.integer  "frequency",                :default => 1,     :null => false
    t.boolean  "success",                  :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["criterion"], :name => "index_searches_on_criterion"
  add_index "searches", ["frequency"], :name => "index_searches_on_frequency"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "email",      :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tips", :force => true do |t|
    t.string   "title",      :limit => 120, :default => "", :null => false
    t.binary   "body",                                      :null => false
    t.integer  "user_id",                   :default => 0,  :null => false
    t.integer  "state",      :limit => 1,   :default => 1,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tips", ["user_id"], :name => "index_tips_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                 :limit => 50, :default => "",   :null => false
    t.string   "username",              :limit => 15, :default => "",   :null => false
    t.string   "hashed_password",       :limit => 64, :default => "",   :null => false
    t.string   "url",                                 :default => "",   :null => false
    t.boolean  "show_email",                          :default => true, :null => false
    t.boolean  "subscribed",                          :default => true, :null => false
    t.boolean  "notify_me",                           :default => true, :null => false
    t.boolean  "use_ajax",                            :default => true, :null => false
    t.text     "about"
    t.string   "token",                 :limit => 16, :default => "",   :null => false
    t.string   "salt",                  :limit => 8,  :default => "",   :null => false
    t.datetime "this_login",                                            :null => false
    t.datetime "last_login",                                            :null => false
    t.integer  "role",                  :limit => 1,  :default => 2,    :null => false
    t.integer  "kudos",                               :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_username",      :limit => 15
    t.string   "working_with_rails_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["kudos"], :name => "index_users_on_kudos"
  add_index "users", ["token"], :name => "index_users_on_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end
