# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :vote do
    proposal # FactoryBot
    user # FactoryBot
    vote { "agree" }
    comment { "my thoughts" }
  end
end
