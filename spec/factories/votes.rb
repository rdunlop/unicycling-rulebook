# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    proposal # FactoryGirl
    user # FactoryGirl
    vote "agree"
    comment "my thoughts"
  end
end
