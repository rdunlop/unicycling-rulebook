# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  comment       :text
#  created_at    :datetime
#  updated_at    :datetime
#  discussion_id :integer
#

class Comment < ActiveRecord::Base
    belongs_to :discussion, touch: true
    belongs_to :user

    validates :discussion, :presence => true
    validates :user, :presence => true
    validates :comment, :presence => true

    attr_accessible :comment

    def proposal
      discussion.proposal
    end
end
