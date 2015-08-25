class RevisionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :proposal
  before_action :set_proposal_breadcrumb
  load_and_authorize_resource :revision, through: :proposal

  # GET /revisions/1
  # GET /revisions/1.json
  def show
    @revision = Revision.find(params[:id])
    add_breadcrumb "Revision #{@revision.num}"
    @comment = @revision.proposal.discussion.comments.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @revision }
    end
  end

  # GET /revisions/new
  # GET /revisions/new.json
  def new
    add_breadcrumb "New Revision"
    @revision = Revision.new
    @revision.background = @proposal.latest_revision.background
    @revision.body = @proposal.latest_revision.body
    @revision.references = @proposal.latest_revision.references
    @revision.rule_text = @proposal.latest_revision.rule_text
    authorize! :revise, @proposal

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @revision }
    end
  end

  # POST /revisions
  # POST /revisions.json
  def create
    @revision.proposal = @proposal
    @revision.user = current_user
    authorize! :revise, @proposal

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
        format.json { render json: [@proposal, @revision], status: :created, location: [@proposal, @revision] }
      else
        add_breadcrumb "New Revision"
        format.html { render action: "new" }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def revision_params
    params.require(:revision).permit(:rule_text, :body, :change_description, :background, :references)
  end
end
