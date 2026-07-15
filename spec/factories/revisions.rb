# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :revision do
    proposal # FactoryBot
    rule_text { "Rule Text" }
    body { "MyText1" }
    background { "MyText2" }
    references { "MyText3" }
    change_description { "MyText4" }
    user # FactoryBot
    num { 1 }
  end
end

# == Schema Information
#
# Table name: revisions
#
#  id                 :integer          not null, primary key
#  proposal_id        :integer
#  body               :text
#  background         :text
#  references         :text
#  change_description :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  num                :integer
#  rule_text          :text
#
