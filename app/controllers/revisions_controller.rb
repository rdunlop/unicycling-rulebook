class RevisionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  before_filter :load_proposal
  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  # GET /revisions/1
  # GET /revisions/1.json
  def show
    @revision = Revision.find(params[:id])
    @comment = @revision.proposal.comments.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @revision }
    end
  end

  # GET /revisions/new
  # GET /revisions/new.json
  def new
    @revision = Revision.new
    @revision.background = @proposal.latest_revision.background
    @revision.body = @proposal.latest_revision.body
    @revision.references = @proposal.latest_revision.references
    authorize! :revise, @proposal

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @revision }
    end
  end

  # POST /revisions
  # POST /revisions.json
  def create
    @revision = Revision.new(params[:revision])
    @revision.proposal = @proposal
    @revision.user = current_user
    authorize! :revise, @proposal

    respond_to do |format|
      if @revision.save
        UserMailer.proposal_revised(@proposal).deliver
        if @proposal.status == 'Pre-Voting'
            @proposal.status = 'Review'
            @proposal.review_start_date = DateTime.now()
            @proposal.review_end_date = DateTime.now() + 3
            @proposal.save
        end
        format.html { redirect_to [@proposal, @revision], notice: 'Revision was successfully created.' }
        format.json { render json: [@proposal, @revision], status: :created, location: [@proposal, @revision] }
      else
        format.html { render action: "new" }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

end
