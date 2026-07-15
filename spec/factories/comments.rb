# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :comment do
    discussion # FactoryBot
    user # FactoryBot
    comment { "MyText" }
  end
end

# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  comment       :text
#  created_at    :datetime
#  updated_at    :datetime
#  discussion_id :integer
#
