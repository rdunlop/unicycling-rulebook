# == Schema Information
#
# Table name: committee_members
#
#  id           :integer          not null, primary key
#  committee_id :integer
#  user_id      :integer
#  voting       :boolean          default(TRUE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  admin        :boolean          default(FALSE), not null
#  editor       :boolean          default(FALSE), not null
#

class CommitteeMember < ActiveRecord::Base
  belongs_to :committee
  belongs_to :user

  validates :committee, :presence => true
  validates :user, :presence => true
  validates :user_id, :uniqueness => {:scope => [:committee_id]}

  scope :admin, -> { where(admin: true) }
end
