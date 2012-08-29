class Proposal < ActiveRecord::Base
    belongs_to :owner, :class_name => "User"

    validates :owner, :presence => true
end
