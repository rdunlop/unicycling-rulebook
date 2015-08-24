# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rulebook do
    rulebook_name "MyString"
    front_page "MyString"
    faq "MyString"

    trait :test_schema do
      subdomain "public"
    end
  end
end
