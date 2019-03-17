# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  user_id     :integer
#  vote        :string
#  created_at  :datetime
#  updated_at  :datetime
#  comment     :text
#

class Vote < ApplicationRecord
  belongs_to :proposal
  belongs_to :user

  validates :proposal, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: {scope: [:proposal_id]}
  validates :vote, inclusion: { in: %w[agree disagree abstain] }

  def to_s
    if self.new_record?
      return ""
    end

    res = user.to_s + " voted " + self.vote + " on " + self.created_at.strftime("%B %d, %Y, %I:%M %p")
    if comment.present?
      res += " (" + self.comment + ")"
    end
    res
  end
end
