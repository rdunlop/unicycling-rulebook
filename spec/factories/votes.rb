# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :vote do
    proposal # FactoryBot
    user # FactoryBot
    vote { "agree" }
    comment { "my thoughts" }
  end
end

# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  user_id     :integer
#  vote        :string
#  created_at  :datetime
#  updated_at  :datetime
#  comment     :text
#
