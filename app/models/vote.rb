class Vote < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :proposal, :presence => true
    validates :user, :presence => true
    validates :comment, :presence => true, :if => "vote == 'disagree'"
    validates :vote, :inclusion => { :in => [ 'agree', 'disagree', 'abstain' ] }
end
