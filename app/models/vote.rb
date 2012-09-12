class Vote < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :proposal, :presence => true
    validates :user, :presence => true
    validates :vote, :inclusion => { :in => [ 'agree', 'disagree', 'abstain' ] }

    attr_accessible :vote, :comment

    def to_s
        if self.new_record?
            return ""
        end
        res = user.to_s + " voted " + self.vote + " on " + self.created_at.strftime("%B %d, %Y, %I:%M %p")
        if not comment.blank?
            res += " (" + self.comment + ")"
        end
        res
    end
end
