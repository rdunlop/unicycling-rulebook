class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :location, :email, :password, :password_confirmation, :remember_me

  has_many :committee_members
  has_many :committees, :through => :committee_members
  has_many :votes

  validates :name, :presence => true

  def is_committee_admin(committee)
    committee_members.each do |cm|
        if cm.committee == committee
            if cm.admin
                return true
            end
        end
    end
    return false
  end

  def is_in_committee(committee)
    committee_members.each do |cm|
        if cm.committee == committee
            return true
        end
    end
    return false
  end

  def voting_member(committee)
    committee_members.each do |cm|
        if cm.committee == committee
            if cm.voting
                return true
            end
        end
    end
    return false
  end

  def voting_text(committee)
    self.voting_member(committee) ? "Voting Member" : "Non-Voting Member"
  end

  def to_s
    name
  end
end
