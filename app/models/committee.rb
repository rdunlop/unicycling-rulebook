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

  has_many :committee_members, -> { includes(:user).order("users.name") }
  has_many :proposals
  has_many :discussions

  after_initialize :init

  scope :ordered, -> { order("preliminary, name") }

  def init
    self.preliminary = false if self.preliminary.nil?
  end

  def to_s
    name
  end
end
