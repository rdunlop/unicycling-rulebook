class ProposalProgressController < ApplicationController
  before_action :authenticate_user!
  before_action :load_and_authorize_proposal

  # PUT /proposals/1/set_voting
  def set_voting

    if @proposal.transition_to("Voting")
      InformCommitteeMembers.proposal_call_for_voting(@proposal)
      redirect_to @proposal, notice: 'Proposal is now in the voting stage.'
    else
      flash[:alert] = "Unable to set to voting"
      redirect_to :back
    end
  end

  # PUT /proposals/1/set_review
  def set_review

    was_tabled = @proposal.status == 'Tabled'

    if @proposal.transition_to("Review")
      InformCommitteeMembers.proposal_status_review(@proposal, was_tabled)
      redirect_to @proposal, notice: 'Proposal is now in the review stage.'
    else
      flash[:alert] = "Unable to set to review"
      redirect_to :back
    end
  end

  # PUT /proposals/1/set_pre_voting
  def set_pre_voting

    if @proposal.transition_to("Pre-Voting")
      @proposal.votes.delete_all
      redirect_to @proposal, notice: 'Proposal is now in the Pre-Voting stage. All votes have been deleted'
    else
      flash[:alert] = "Unable to set to pre-voting"
      redirect_to :back
    end
  end

  # PUT /proposals/1/table
  def table

    if @proposal.transition_to("Tabled")
      redirect_to @proposal, notice: 'Proposal has been Set-Aside'
    else
      flash[:alert] = "Unable to set status to Tabled unless in 'Pre-Voting' or 'Review' state"
      redirect_to :back
    end
  end

  private

  def load_and_authorize_proposal
    @proposal = Proposal.find(params[:id])
    authorize @proposal
  end

  def load_committee
    @committee = Committee.find(params[:committee_id])
  end

  def proposal_params
    params.require(:proposal).permit(:title)
  end

  def update_params
    params.require(:proposal).permit(:title, :committee_id, :status, :review_start_date, :review_end_date, :vote_start_date, :vote_end_date, :tabled_date)
  end

  # XXX should be in revision-controller?
  def revision_params
    params.require(:revision).permit(:rule_text, :body, :change_description, :background, :references)
  end

end
