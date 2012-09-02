class Proposal < ActiveRecord::Base
    belongs_to :owner, :class_name => "User"
    belongs_to :committee
    has_many :votes
    has_many :comments

    validates :owner, :presence => true
    validates :title, :presence => true
    validates :committee, :presence => true
    validates :status, :inclusion => { :in => [ 'Submitted', 'Review', 'Pre-Voting', 'Voting', 'Tabled', 'Passed', 'Failed' ] }

    def to_s
        title
    end
end
