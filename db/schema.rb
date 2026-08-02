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

ActiveRecord::Schema[8.1].define(version: 2025_04_03_144549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.integer "discussion_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "committee_members", id: :serial, force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.integer "committee_id"
    t.datetime "created_at", precision: nil
    t.boolean "editor", default: false, null: false
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.boolean "voting", default: true, null: false
  end

  create_table "committees", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.boolean "preliminary", default: true, null: false
    t.boolean "private", default: false, null: false
    t.datetime "updated_at", precision: nil
  end

  create_table "discussions", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "committee_id"
    t.datetime "created_at", precision: nil
    t.integer "owner_id"
    t.integer "proposal_id"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", precision: nil
  end

  create_table "proposals", id: :serial, force: :cascade do |t|
    t.integer "committee_id"
    t.datetime "created_at", precision: nil
    t.string "mail_messageid"
    t.integer "owner_id"
    t.date "review_end_date"
    t.date "review_start_date"
    t.string "status"
    t.date "submit_date"
    t.date "tabled_date"
    t.text "title"
    t.boolean "transition_straight_to_vote", default: true, null: false
    t.datetime "updated_at", precision: nil
    t.date "vote_end_date"
    t.date "vote_start_date"
  end

  create_table "revisions", id: :serial, force: :cascade do |t|
    t.text "background"
    t.text "body"
    t.text "change_description"
    t.datetime "created_at", precision: nil
    t.integer "num"
    t.integer "proposal_id"
    t.text "references"
    t.text "rule_text"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "rulebooks", id: :serial, force: :cascade do |t|
    t.string "admin_upgrade_code"
    t.string "copyright"
    t.datetime "created_at", precision: nil
    t.text "faq"
    t.text "front_page"
    t.boolean "proposals_allowed", default: true, null: false
    t.integer "review_days", default: 5, null: false
    t.string "rulebook_name"
    t.string "subdomain"
    t.datetime "updated_at", precision: nil
    t.integer "voting_days", default: 5, null: false
    t.index ["subdomain"], name: "index_rulebooks_on_subdomain", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.text "comments"
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.string "location"
    t.string "name"
    t.boolean "no_emails", default: false, null: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.integer "proposal_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.string "vote"
  end
end
