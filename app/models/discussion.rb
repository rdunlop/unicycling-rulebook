# == Schema Information
#
# Table name: discussions
#
#  id           :integer          not null, primary key
#  proposal_id  :integer
#  title        :string(255)
#  status       :string(255)
#  owner_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  committee_id :integer
#  body         :text
#

class Discussion < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :proposal, touch: true, inverse_of: :discussion
  belongs_to :committee
  has_many :comments, -> { order("created_at ASC") }

  validates :owner, :title, :committee, presence: true
  validates :status, inclusion: { in: [ 'active', 'closed' ] }

  def self.active
    where(status: 'active')
  end

  def self.closed
    where(status: 'closed')
  end

  # discussions without a matching proposal, or with a matching proposal in 'Submitted' status.
  def self.without_approved_proposal
    joins('LEFT OUTER JOIN proposals on proposals.id = discussions.proposal_id').where("proposals.id IS NULL OR proposals.status = 'Submitted'")
  end

  def self.with_approved_proposal
    joins(:proposal).merge(Proposal.where.not(status: ['Submitted', 'Passed']))
  end

  def self.with_passed_proposal
    joins(:proposal).merge(Proposal.where(status: 'Passed'))
  end

  def self.reverse_chronological
    order(updated_at: :desc)
  end

  def self.without_proposals
    where(proposal: nil)
  end

  def active?
    status == "active"
  end

  def closed?
    status == "closed"
  end

  def is_open_for_comments?
    active? && proposal_commentable?
  end

  def proposal_commentable?
    return true if proposal.nil?
    proposal.is_open_for_comments?
  end

  def close
    return false if proposal.present?
    update!(status: "closed")
  end

  # this will change as the discussion becomes a proposal
  def display_title
    if closed?
      "#{title} (Closed for comments)"
    else
      title
    end
  end

  def to_s
    title
  end
end
