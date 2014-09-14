# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :proposal do
    committee # FactoryGirl
    status "Submitted"
    submit_date "2011-08-29 14:43:59"
    review_start_date "2011-08-29 14:43:59"
    review_end_date "2011-08-29 14:43:59"
    vote_start_date "2011-08-29 14:43:59"
    vote_end_date "2011-08-29 14:43:59"
    tabled_date "2011-08-29 14:43:59"
    transition_straight_to_vote false
    owner
    sequence(:title) {|e| "Proposal Title #{e}" }
    mail_messageid nil

    trait :submitted do
      status "Submitted"
    end

    trait :review do
      status "Review"
    end

    trait :with_admin do
      after(:create) do |proposal|
        FactoryGirl.create(:committee_member, :admin, committee: proposal.committee)
      end
    end
  end
end
