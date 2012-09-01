class CommitteeMember < ActiveRecord::Base
    belongs_to :committee
    belongs_to :user

    validates :committee, :presence => true
    validates :user, :presence => true
end
