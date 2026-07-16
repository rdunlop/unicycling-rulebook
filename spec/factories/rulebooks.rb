# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :rulebook do
    rulebook_name { "MyString" }
    front_page { "MyString" }
    faq { "MyString" }

    trait :test_schema do
      subdomain { "public" }
    end
  end
end

# == Schema Information
#
# Table name: public.rulebooks
#
#  id                 :integer          not null, primary key
#  rulebook_name      :string
#  front_page         :text
#  faq                :text
#  created_at         :datetime
#  updated_at         :datetime
#  copyright          :string
#  subdomain          :string
#  admin_upgrade_code :string
#  proposals_allowed  :boolean          default(TRUE), not null
#  voting_days        :integer          default(5), not null
#  review_days        :integer          default(5), not null
#
# Indexes
#
#  index_rulebooks_on_subdomain  (subdomain) UNIQUE
#
