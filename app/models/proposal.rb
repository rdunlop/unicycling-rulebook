class Proposal < ActiveRecord::Base
    belongs_to :owner, :class_name => "User"
    belongs_to :committee

    validates :owner, :presence => true
    validates :title, :presence => true
    validates :committee, :presence => true
end
