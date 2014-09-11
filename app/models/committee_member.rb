# == Schema Information
#
# Table name: committee_members
#
#  id           :integer          not null, primary key
#  committee_id :integer
#  user_id      :integer
#  voting       :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  admin        :boolean          default(FALSE)
#  editor       :boolean          default(FALSE)
#

class CommitteeMember < ActiveRecord::Base
    belongs_to :committee
    belongs_to :user

    validates :committee, :presence => true
    validates :user, :presence => true
    validates :user_id, :uniqueness => {:scope => [:committee_id]}

    attr_accessible :committee_id, :admin, :editor, :voting, :user_id
end
