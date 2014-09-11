# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  user_id     :integer
#  comment     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :proposal, :presence => true
    validates :user, :presence => true
    validates :comment, :presence => true

    attr_accessible :comment
end
