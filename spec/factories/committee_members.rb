# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :committee_member do
    committee # FactoryBot
    user # FactoryBot
    admin { false }
    voting { true }
    editor { false }

    trait :admin do
      admin { true }
    end
  end
end
