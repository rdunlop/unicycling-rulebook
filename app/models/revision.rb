# == Schema Information
#
# Table name: revisions
#
#  id                 :integer          not null, primary key
#  proposal_id        :integer
#  body               :text
#  background         :text
#  references         :text
#  change_description :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  num                :integer
#  rule_text          :text
#

class Revision < ApplicationRecord
  belongs_to :proposal, touch: true, inverse_of: :revisions
  belongs_to :user

  validates :body, presence: true
  validate :change_description_required_for_updates

  before_validation :determine_num

  def determine_num
    self.num = if proposal.nil? or proposal.new_record?
                 1
               else
                 (proposal.revisions - [self]).count + 1
               end
  end

  def change_description_required_for_updates
    if not self.new_record?
      return
    end

    if self.change_description.blank?
      if self.proposal
        if self.proposal.revisions.count.positive?
          errors.add(:change_description, message: "Change Description field must be present for all Revisions")
        end
      end
    end
  end
end
