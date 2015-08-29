class RevisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_proposal
  before_action :set_proposal_breadcrumb

  # GET /proposals/:proposal_id/revisions/1
  def show
    @revision = @proposal.revisions.find(params[:id])
    authorize @revision
    add_breadcrumb "Revision #{@revision.num}"
    @comment = @revision.proposal.discussion.comments.new

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /proposals/:proposal_id/revisions/new
  def new
    add_breadcrumb "New Revision"
    @revision = Revision.new
    @revision.background = @proposal.latest_revision.background
    @revision.body = @proposal.latest_revision.body
    @revision.references = @proposal.latest_revision.references
    @revision.rule_text = @proposal.latest_revision.rule_text
    authorize @revision
    authorize @proposal, :revise?

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /proposals/:proposal_id/revisions
  def create
    @revision = @proposal.revisions.new(revision_params)
    @revision.proposal = @proposal
    @revision.user = current_user
    authorize @revision

    respond_to do |format|
      if @revision.save
        InformCommitteeMembers.proposal_revised(@revision)
        if @proposal.status == 'Pre-Voting'
          @proposal.status = 'Review'
          @proposal.review_start_date = DateTime.now()
          @proposal.review_end_date = DateTime.now() + 3
          @proposal.save
        end
        format.html { redirect_to [@proposal, @revision], notice: 'Revision was successfully created.' }
      else
        add_breadcrumb "New Revision"
        format.html { render action: "new" }
      end
    end
  end

  private

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def revision_params
    params.require(:revision).permit(:rule_text, :body, :change_description, :background, :references)
  end
end
