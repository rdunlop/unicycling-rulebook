class Comment < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :proposal, :presence => true
    validates :user, :presence => true
    validates :comment, :presence => true

    attr_accessible :comment
end
