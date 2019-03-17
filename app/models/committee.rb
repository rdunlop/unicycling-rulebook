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

class Committee < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :committee_members, -> { includes(:user).order("users.name") }, inverse_of: :committee
  has_many :proposals
  has_many :discussions

  scope :ordered, -> { order("preliminary, id") }

  def discussions_without_approved_proposals
    discussions.active.without_approved_proposal
  end

  def discussions_with_active_proposals
    discussions.active.with_approved_proposal
  end

  def discussions_with_passed_proposals
    discussions.active.with_passed_proposal
  end

  def to_s
    name
  end
end
