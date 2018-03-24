class ProposalCreator
  attr_accessor :proposal, :revision, :existing_discussion, :user

  def initialize(proposal, revision, existing_discussion, user)
    @proposal = proposal
    @revision = revision
    @user = user
    @existing_discussion = existing_discussion

    @proposal.owner = user
    @revision.user = user
    @proposal.submit_date = Date.current
    @proposal.status = "Submitted"
  end

  def perform
    return false if not entries_valid?
    begin
      Proposal.transaction do
        proposal.save!
        if existing_discussion
          existing_discussion.proposal = proposal
          existing_discussion.save!
        else
          create_discussion_for(proposal)
        end
        revision.proposal = proposal
        revision.save!
      end
      true
    rescue StandardError
      false
    end
  end

  private

  def entries_valid?
    proposal.valid? && revision.valid?
  end

  def create_discussion_for(proposal)
    discussion = Discussion.new
    discussion.committee = proposal.committee
    discussion.proposal = proposal
    discussion.title = proposal.title
    discussion.owner = proposal.owner
    discussion.status = "active"
    discussion.save!
  end
end
