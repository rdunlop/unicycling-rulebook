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

    respond_to do |format|
      if @revision.save
        format.html { redirect_to [@proposal, @revision], notice: 'Revision was successfully created.' }
        format.json { render json: [@proposal, @revision], status: :created, location: [@proposal, @revision] }
      else
        format.html { render action: "new" }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

end
