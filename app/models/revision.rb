class Revision < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :body, :presence => true
    validate :change_description_required_for_updates

    def change_description_required_for_updates
        if self.change_description.blank?
            if self.proposal
                if self.proposal.revisions.count > 0
                    errors[:change_description] << "Change Description field must be present for all Revisions"
                end
            end
        end
    end
end
