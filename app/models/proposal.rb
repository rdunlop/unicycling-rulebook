# == Schema Information
#
# Table name: proposals
#
#  id                          :integer          not null, primary key
#  committee_id                :integer
#  status                      :string(255)
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
#  mail_messageid              :string(255)
#

class Proposal < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :committee
  has_many :votes, -> { order("created_at ASC") }
  has_many :comments, through: :discussion
  has_one :discussion, inverse_of: :proposal
  has_many :revisions, -> { order("id DESC") }

  validates :owner, presence: true
  validates :title, presence: true
  validates :committee, presence: true
  validates :status, inclusion: { in: ['Submitted', 'Review', 'Pre-Voting', 'Voting', 'Tabled', 'Passed', 'Failed'] }

  # This is the auto-updated function CLASS METHOD
  def self.update_states
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        update_proposal_states
      end
    end
  end

  def self.update_proposal_states
    Proposal.all.each do |proposal|
      if proposal.status == 'Review' and proposal.review_end_date < Date.current
        proposal.update_attribute(:status, 'Pre-Voting')
        UserMailer.delay.proposal_finished_review(proposal)
      elsif proposal.status == 'Voting' && (proposal.vote_end_date < Date.current || proposal.all_voting_members_voted)
        if proposal.have_voting_quorum && proposal.at_least_two_thirds_agree
          proposal.update_attribute(:status, 'Passed')
        else
          proposal.update_attribute(:status, 'Failed')
        end
        InformCommitteeMembers.proposal_voting_result(proposal, proposal.status == 'Passed')
      end
    end
  end

  def at_least_two_thirds_agree
    votes_which_count = agree_votes + disagree_votes
    (self.agree_votes / votes_which_count.to_f) >= (2 / 3.0)
  end

  def have_voting_quorum
    return false if number_of_voting_members == 0

    (votes.count / number_of_voting_members.to_f) >= 0.50
  end

  def number_of_voting_members
    committee.committee_members.voting.count
  end

  delegate :is_open_for_comments?, :transition_to, to: :state

  def state
    class_name = BaseState.get_state(status)
    class_name.new(self)
  end

  def all_voting_members_voted
    number_of_voting_members == votes.count
  end

  def latest_revision
    if self.revisions.empty?
      nil
    else
      self.revisions.first
    end
  end

  def latest_revision_number
    if self.latest_revision.nil?
      0
    else
      self.latest_revision.num
    end
  end

  def find_vote_for(user)
    votes.find_by(user: user) || votes.new
  end

  delegate :background, :body, :references, to: :latest_revision

private
  def count_votes(type)
    votes.where(vote: type).count
  end

public
  def agree_votes
    count_votes('agree')
  end
  def disagree_votes
    count_votes('disagree')
  end
  def abstain_votes
    count_votes('abstain')
  end

  delegate :status_summary, :status_string, to: :state

  def vote_detail(user_votes)
    user_votes.each do |v|
      if v.proposal == self
        return v.vote
      end
    end
    ""
  end

  def to_s
    title
  end
end
