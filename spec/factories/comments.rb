# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :comment do
    discussion # FactoryBot
    user # FactoryBot
    comment { "MyText" }
  end
end
