class RemoveCommentProposalAssociation < ActiveRecord::Migration[4.2]
  class Comment < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :discussion
  end

  class Discussion < ActiveRecord::Base
    belongs_to :proposal
  end

  class Proposal < ActiveRecord::Base
    has_many :comments
  end

  def up
    remove_column :comments, :proposal_id
  end

  def down
    add_column :comments, :proposal_id, :integer
    Comment.reset_column_information
    Comment.all.each do |comment|
      comment.proposal = comment.discussion.proposal
      comment.save!
    end
  end
end
