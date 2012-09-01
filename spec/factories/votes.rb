# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    proposal_id 1
    user_id 1
    vote "MyString"
  end
end
