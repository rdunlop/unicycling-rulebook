# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :committee_member do
    committee # FactoryBot
    user # FactoryBot
    admin { false }
    voting { true }
    editor { false }

    trait :admin do
      admin { true }
    end
  end
end

# == Schema Information
#
# Table name: committee_members
#
#  id           :integer          not null, primary key
#  committee_id :integer
#  user_id      :integer
#  voting       :boolean          default(TRUE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  admin        :boolean          default(FALSE), not null
#  editor       :boolean          default(FALSE), not null
#
