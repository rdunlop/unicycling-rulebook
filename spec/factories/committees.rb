# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :committee do
    sequence(:name) { |n| "Rulebook Committee #{n}" }
    preliminary false
  end
end
