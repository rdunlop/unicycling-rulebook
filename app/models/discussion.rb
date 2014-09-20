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
  belongs_to :owner, :class_name => "User"
  belongs_to :proposal, touch: true
  belongs_to :committee
  has_many :comments, -> { order("created_at ASC") }

  validates :owner, :title, :committee, :presence => true
  validates :status, :inclusion => { :in => [ 'active', 'closed' ] }

  def self.reverse_chronological
    order(updated_at: :desc)
  end

  def self.without_proposals
    where(proposal: nil)
  end

  def active?
    status == "active"
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
    title
  end

  def to_s
    title
  end
end
