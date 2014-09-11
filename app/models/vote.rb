# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  user_id     :integer
#  vote        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  comment     :text
#

class Vote < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :proposal, :presence => true
    validates :user, :presence => true
    validates :user_id, :uniqueness => {:scope => [:proposal_id]}
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
