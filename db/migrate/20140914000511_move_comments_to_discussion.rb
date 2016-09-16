class MoveCommentsToDiscussion < ActiveRecord::Migration
  class Comment < ActiveRecord::Base
    belongs_to :proposal
    belongs_to :discussion
  end

  class Discussion < ActiveRecord::Base
  end

  class Proposal < ActiveRecord::Base
    has_many :comments
  end

  def up
    Proposal.reset_column_information

    Proposal.all.each do |proposal|
      discussion = Discussion.new(
        proposal_id: proposal.id,
        title: proposal.title,
        status: determine_status(proposal.status),
        owner_id: proposal.owner_id
      )
      discussion.save!
      proposal.comments.each do |comment|
        comment.discussion = discussion
        comment.save!
      end
    end
  end

  def down
    Discussion.destroy_all
  end

  def determine_status(proposal_status)
    if proposal_status.in?(['Submitted', 'Review'])
      "active"
    else
      "closed"
    end
  end
end
