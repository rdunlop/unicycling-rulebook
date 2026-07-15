# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:name) { |n| "person #{n}" }
    location { 'Chicago' }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'please' }
    password_confirmation { 'please' }
    comments { '' }
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now

    factory :admin_user do
      admin { true }
    end
    confirmed_at { Time.now }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE), not null
#  name                   :string
#  location               :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  comments               :text
#  no_emails              :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
