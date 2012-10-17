class Committee < ActiveRecord::Base
    validates :name, :presence => true, :uniqueness => true

    has_many :committee_members, :include => :user, :order => "users.name"
    has_many :proposals

    attr_accessible :name, :preliminary

    after_initialize :init

    def init
        self.preliminary = false if self.preliminary.nil?
    end

    def to_s
        name
    end
end
