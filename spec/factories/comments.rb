# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    proposal # FactoryGirl
    user # FactoryGirl
    comment "MyText"
  end
end
