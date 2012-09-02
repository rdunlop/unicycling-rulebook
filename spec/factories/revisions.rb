# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :revision do
    proposal # FactoryGirl
    body "MyText1"
    background "MyText2"
    references "MyText3"
    change_description "MyText4"
    user # FactoryGirl
  end
end
