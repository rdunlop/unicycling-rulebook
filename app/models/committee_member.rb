class CommitteeMember < ActiveRecord::Base
    belongs_to :committee
    belongs_to :user

    validates :committee, :presence => true
    validates :user, :presence => true
    validates :user_id, :uniqueness => {:scope => [:committee_id]}

    attr_accessible :committee_id, :admin, :voting, :user_id
end
