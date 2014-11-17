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
  belongs_to :owner, :class_name => "User"
  belongs_to :committee
  has_many :votes, -> { order("created_at ASC") }
  has_many :comments, through: :discussion
  has_one :discussion
  has_many :revisions, -> { order("id DESC") }

  validates :owner, :presence => true
  validates :title, :presence => true
  validates :committee, :presence => true
  validates :status, :inclusion => { :in => [ 'Submitted', 'Review', 'Pre-Voting', 'Voting', 'Tabled', 'Passed', 'Failed' ] }

  # This is the auto-updated function CLASS METHOD
  def self.update_states
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant)
      update_proposal_states
    end
  end

  def self.update_proposal_states
    Proposal.all.each do |proposal|
      if proposal.status == 'Review' and proposal.review_end_date < Date.today
        proposal.status = 'Pre-Voting'
        puts "Changing Proposal #{proposal.title} from Review to Pre-Voting"
        proposal.save
        UserMailer.delay.proposal_finished_review(proposal.id)
      elsif proposal.status == 'Voting' and (proposal.vote_end_date < Date.today or proposal.all_voting_members_voted)
        if proposal.have_voting_quorum and proposal.at_least_two_thirds_agree
          proposal.status = 'Passed'
        else
          proposal.status = 'Failed'
        end
        puts "Changing Proposal #{proposal.title} from Voting to #{proposal.status}"
        proposal.save
        InformCommitteeMembers.proposal_voting_result(proposal, proposal.status == 'Passed')
      end
    end
  end

  def at_least_two_thirds_agree
    votes_which_count = self.agree_votes + self.disagree_votes
    (self.agree_votes / votes_which_count.to_f) >= (2 / 3.0)
  end

  def have_voting_quorum
    if number_of_voting_members == 0
      return false
    end

    if (self.votes.count / number_of_voting_members.to_f) >= 0.50
      true
    else
      false
    end
  end

  def number_of_voting_members
    x = self.committee.committee_members.select {|cm| cm.voting }
    x.count
  end

  def is_open_for_comments?
    state.is_open_for_comments?
  end

  delegate :transition_to, to: :state

  def state
    class_name = BaseState.get_state(status)
    class_name.new(self)
  end

  def all_voting_members_voted
    self.number_of_voting_members == self.votes.count
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

  def background
    self.latest_revision.background
  end

  def body
    self.latest_revision.body
  end

  def references
    self.latest_revision.references
  end

private
  def count_votes(type)
    count = 0
    votes.each do |v|
      if v.vote == type
        count += 1
      end
    end
    count
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

  def status_summary
    state.status_summary
  end

  def vote_detail(user_votes)
    user_votes.each do |v|
      if v.proposal == self
        return v.vote
      end
    end
    ""
  end

  def status_string
    state.status_string
  end

  def to_s
    title
  end
end
