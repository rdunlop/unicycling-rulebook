# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :aliases => [:owner] do
    sequence(:name) {|n| "person #{n}" }
    location 'Chicago'
    sequence(:email) {|n| "person#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now

    factory :admin_user do
        admin true
    end
    after_create { |user| user.confirm! }
  end
end
