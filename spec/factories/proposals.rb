# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :proposal do
    committee # FactoryBot
    status { "Submitted" }
    submit_date { "2011-08-29 14:43:59" }
    review_start_date { "2011-08-29 14:43:59" }
    review_end_date { "2011-08-29 14:43:59" }
    vote_start_date { "2011-08-29 14:43:59" }
    vote_end_date { "2011-08-29 14:43:59" }
    tabled_date { "2011-08-29 14:43:59" }
    transition_straight_to_vote { false }
    owner
    sequence(:title) { |e| "Proposal Title #{e}" }
    mail_messageid { nil }

    after(:create) do |proposal|
      proposal.discussion ||= FactoryBot.create(:discussion, proposal: proposal)
    end

    trait :submitted do
      status { "Submitted" }
    end

    trait :review do
      status { "Review" }
    end

    trait :set_aside do
      status { "Tabled" }
    end

    trait :failed do
      status { "Failed" }
    end

    trait :with_admin do
      after(:create) do |proposal|
        FactoryBot.create(:committee_member, :admin, committee: proposal.committee)
      end
    end
  end
end

# == Schema Information
#
# Table name: proposals
#
#  id                          :integer          not null, primary key
#  committee_id                :integer
#  status                      :string
#  submit_date                 :date
#  review_start_date           :date
#  review_end_date             :date
#  vote_start_date             :date
#  vote_end_date               :date
#  tabled_date                 :date
#  transition_straight_to_vote :boolean          default(TRUE), not null
#  owner_id                    :integer
#  title                       :text
#  created_at                  :datetime
#  updated_at                  :datetime
#  mail_messageid              :string
#
