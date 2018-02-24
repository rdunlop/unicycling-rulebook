# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :discussion do
    # proposal # FactoryBot
    status "active"
    owner
    sequence(:title) { |e| "Discussion Title #{e}" }
    after(:build) do |discussion|
      discussion.committee = if discussion.proposal.present?
                               discussion.proposal.committee
                             else
                               FactoryBot.build(:committee)
                             end
    end
  end
end
