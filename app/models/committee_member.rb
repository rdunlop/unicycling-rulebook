# == Schema Information
#
# Table name: committee_members
#
#  id           :integer          not null, primary key
#  committee_id :integer
#  user_id      :integer
#  voting       :boolean          default(TRUE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  admin        :boolean          default(FALSE), not null
#  editor       :boolean          default(FALSE), not null
#

class CommitteeMember < ApplicationRecord
  belongs_to :committee, inverse_of: :committee_members
  belongs_to :user, inverse_of: :committee_members

  validates :committee, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: {scope: [:committee_id]}

  scope :admin, -> { where(admin: true) }
  scope :voting, -> { where(voting: true) }

  def voting_text
    voting? ? "Voting Member" : "Non-Voting Member"
  end
end
