# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :committee do
    sequence(:name) { |n| "Rulebook Committee #{n}" }
    preliminary { false }
  end
end

# == Schema Information
#
# Table name: committees
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime
#  updated_at  :datetime
#  preliminary :boolean          default(TRUE), not null
#  private     :boolean          default(FALSE), not null
#
