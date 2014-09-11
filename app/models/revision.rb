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

class Revision < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :body, :presence => true
    validate :change_description_required_for_updates

    attr_accessible :rule_text, :body, :change_description, :background, :references

    before_validation :determine_num

    def determine_num
        if proposal.nil? or proposal.new_record?
            self.num = 1
        else
            self.num = proposal.revisions.count + 1
        end
    end


    def change_description_required_for_updates
        if not self.new_record?
            return
        end
        if self.change_description.blank?
            if self.proposal
                if self.proposal.revisions.count > 0
                    errors[:change_description] << "Change Description field must be present for all Revisions"
                end
            end
        end
    end
end
