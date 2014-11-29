# == Schema Information
#
# Table name: committees
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  preliminary :boolean          default(TRUE), not null
#

class Committee < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  has_many :committee_members, -> { includes(:user).order("users.name") }, inverse_of: :committee
  has_many :proposals
  has_many :discussions

  scope :ordered, -> { order("preliminary, id") }

  def to_s
    name
  end
end
