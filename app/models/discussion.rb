# == Schema Information
#
# Table name: discussions
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  title       :string(255)
#  status      :string(255)
#  owner_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Discussion < ActiveRecord::Base
    belongs_to :owner, :class_name => "User"
    belongs_to :proposal
    has_many :comments, -> { order("created_at ASC") }

    validates :owner, :presence => true
    validates :title, :presence => true
    validates :status, :inclusion => { :in => [ 'active', 'closed' ] }

    attr_accessible :title, :owner_id, :proposal_id, :status

    def last_update_time
      last_time = self.created_at
      if self.comments.count > 0
        last_comment = self.comments.last
        if last_time < last_comment.created_at
          last_time = last_comment.created_at
        end
      end
      last_time
    end

    def to_s
        title
    end
end
