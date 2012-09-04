class Committee < ActiveRecord::Base
    validates :name, :presence => true, :uniqueness => true

    has_many :committee_members
    has_many :proposals

    def to_s
        name
    end
end
