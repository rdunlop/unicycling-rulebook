# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:name) { |n| "person #{n}" }
    location 'Chicago'
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
    comments ''
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now

    factory :admin_user do
      admin true
    end
    confirmed_at Time.now
  end
end
