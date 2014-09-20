class ProposalCreator
  attr_accessor :proposal, :revision, :user

  def initialize(proposal, revision, user)
    @proposal = proposal
    @revision = revision
    @user = user

    @proposal.owner = user
    @revision.user = user
    @proposal.submit_date = Date.today
    @proposal.status = "Submitted"
  end

  def perform
    return false if not entries_valid?
    begin
      Proposal.transaction do
        proposal.save!
        create_discussion_for(proposal)
        revision.proposal = proposal
        revision.save!
      end
      true
    rescue
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
