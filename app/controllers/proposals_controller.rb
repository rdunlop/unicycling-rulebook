class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /proposals
  # GET /proposals.json
  def index
    @proposals = Proposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])
    @comment = @proposal.comments.new

    # XXX why is this always available?
    if can? :vote, @proposal
        @vote = @proposal.votes.new
        @proposal.votes.each do |v|
            if v.user == current_user
                @vote = v
            end
        end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new
    @proposal.owner = current_user
    @revision = Revision.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.status = 'Submitted'
    @proposal.owner = current_user
    @proposal.submit_date = DateTime.now()

    @revision = Revision.new(params[:revision])
    @revision.user = current_user

    respond_to do |format|
      if @proposal.valid? and @revision.valid?
        @proposal.save
        @revision.proposal = @proposal
        if @revision.save
          UserMailer.proposal_submitted(@proposal).deliver
          format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
          format.json { render json: @proposal, status: :created, location: @proposal }
        else
          format.html { render action: "new" }
          format.json { render json: @proposal.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :no_content }
    end
  end

  # PUT /proposals/1/set_voting
  def set_voting
    @proposal = Proposal.find(params[:id])

    if @proposal.status == "Pre-Voting"
        proceed = true
    else
        proceed = false
    end
    @proposal.status = "Voting"
    @proposal.vote_start_date = DateTime.now()

    respond_to do |format|
      if proceed and @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal is now in the voting stage.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1/set_review
  def set_review
    @proposal = Proposal.find(params[:id])

    if (@proposal.status == "Submitted") or (@proposal.status == "Tabled")
        proceed = true
    else
        proceed = false
    end
    @proposal.status = "Review"
    @proposal.review_start_date = DateTime.now()

    respond_to do |format|
      if proceed and @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal is now in the review stage.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1/set_pre_voting
  def set_pre_voting
    @proposal = Proposal.find(params[:id])

    if (@proposal.status == "Voting")
        proceed = true
    else
        proceed = false
    end
    @proposal.status = "Pre-Voting"

    respond_to do |format|
      if proceed and @proposal.votes.delete_all and @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal is now in the Pre-Voting stage. All votes have been deleted' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end
end
