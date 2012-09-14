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

ActiveRecord::Schema.define(:version => 20120914041730) do

  create_table "comments", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "committee_members", :force => true do |t|
    t.integer  "committee_id"
    t.integer  "user_id"
    t.boolean  "voting"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "admin",        :default => false
  end

  create_table "committees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "proposals", :force => true do |t|
    t.integer  "committee_id"
    t.string   "status"
    t.date     "submit_date"
    t.date     "review_start_date"
    t.date     "review_end_date"
    t.date     "vote_start_date"
    t.date     "vote_end_date"
    t.date     "tabled_date"
    t.boolean  "transition_straight_to_vote"
    t.integer  "owner_id"
    t.text     "summary"
    t.text     "title"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "revisions", :force => true do |t|
    t.integer  "proposal_id"
    t.text     "body"
    t.text     "background"
    t.text     "references"
    t.text     "change_description"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "num"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "name"
    t.string   "location"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "comments"
    t.boolean  "no_emails"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.string   "vote"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "comment"
  end

end
