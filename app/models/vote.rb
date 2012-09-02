class Vote < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :proposal, :presence => true
    validates :user, :presence => true
    validates :comment, :presence => true, :if => "vote == 'disagree'"
    validates :vote, :inclusion => { :in => [ 'agree', 'disagree', 'abstain' ] }

    def to_s
        res = "<b>" + user.to_s + "</b>" +
              " voted <strong>" + vote + "</strong>" +
              " on <i>" + self.created_at.strftime("%B %d, %Y, %I:%M %p") + "</i>"
        if not comment.blank?
            res += "<blockquote>" + self.comment + "</blockquote>"
        end
        res
    end
end
