# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :discussion do
    #proposal # FactoryGirl
    status "active"
    owner
    sequence(:title) {|e| "Discussion Title #{e}" }
    after(:build) do |discussion|
      discussion.committee = if discussion.proposal.present?
                               discussion.proposal.committee
                             else
                               FactoryGirl.build(:committee)
                            end
    end
  end
end
