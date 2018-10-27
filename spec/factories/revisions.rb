# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :revision do
    proposal # FactoryBot
    rule_text { "Rule Text" }
    body { "MyText1" }
    background { "MyText2" }
    references { "MyText3" }
    change_description { "MyText4" }
    user # FactoryBot
    num { 1 }
  end
end
