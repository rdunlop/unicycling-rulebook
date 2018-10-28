class AddCommitteeIdToDiscussion < ActiveRecord::Migration[4.2]
  class Proposal < ActiveRecord::Base
    belongs_to :committee
    has_one :discussion
  end

  class Committee < ActiveRecord::Base
    has_many :proposals
  end

  class Discussion < ActiveRecord::Base
    belongs_to :proposal
  end

  def up
    add_column :discussions, :committee_id, :integer
    Discussion.all.each do |discussion|
      discussion.update_attribute(:committee_id, discussion.proposal.committee_id)
    end
  end

  def down
    remove_column :discussions, :committee_id
  end
end
