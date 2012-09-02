class Revision < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :user

    validates :body, :presence => true
    validates :change_description, :presence => true
end
