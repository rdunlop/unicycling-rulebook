class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :passed]
  load_and_authorize_resource

  # GET /proposals/passed
  # GET /proposals/passed.json
  def passed
    # the non-preliminary ones go first
    @proposals = Proposal.select{ |p| p.committee.preliminary == false and p.status == 'Passed'}
    @proposals += Proposal.select{ |p| p.committee.preliminary == true and p.status == 'Passed'}

    respond_to do |format|
      format.html # passed.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])

    @proposal.votes.each do |v|
      if v.user == current_user
        @vote = v
      end
    end
    if can? :vote, @proposal
      if @vote.nil?
        @vote = @proposal.votes.new
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
    @committees = current_user.accessible_committees

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
    @committees = current_user.accessible_committees
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.status = 'Submitted'
    @proposal.owner = current_user
    @proposal.submit_date = Date.today()

    @revision = Revision.new(params[:revision])
    @revision.user = current_user

    @committees = current_user.accessible_committees

    respond_to do |format|
      if @proposal.valid? and @revision.valid?
        @proposal.save
        create_discussion_for(@proposal)
        @revision.proposal = @proposal
        if @revision.save
          mail = UserMailer.proposal_submitted(@proposal).deliver
          @proposal.mail_messageid = mail.message_id
          @proposal.save
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

  private

  def create_discussion_for(proposal)
    discussion = Discussion.new
    discussion.proposal = proposal
    discussion.title = proposal.title
    discussion.owner = proposal.owner
    discussion.status = "active"
    discussion.save
  end

  public

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
    @proposal.vote_start_date = Date.today()
    @proposal.vote_end_date = @proposal.vote_start_date.next_day(7)

    respond_to do |format|
      if proceed and @proposal.save
        UserMailer.proposal_call_for_voting(@proposal).deliver
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

    was_tabled = @proposal.status == 'Tabled'
    if (@proposal.status == "Submitted") or (@proposal.status == "Tabled")
      proceed = true
    else
      proceed = false
    end
    @proposal.status = "Review"
    @proposal.review_start_date = Date.today()
    @proposal.review_end_date = @proposal.review_start_date.next_day(10)

    respond_to do |format|
      if proceed and @proposal.save
        UserMailer.proposal_status_review(@proposal, was_tabled).deliver
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
      @proposal.votes.delete_all
    else
      proceed = false
    end
    @proposal.status = "Pre-Voting"

    respond_to do |format|
      if proceed && @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal is now in the Pre-Voting stage. All votes have been deleted' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1/table
  def table
    @proposal = Proposal.find(params[:id])

    if (@proposal.status == "Pre-Voting" or @proposal.status == "Review")
      proceed = true
    else
      proceed = false
    end
    @proposal.status = "Tabled"
    @proposal.tabled_date = Date.today()

    respond_to do |format|
      if proceed and @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal has been Set-Aside' }
        format.json { head :no_content }
      else
        @proposal.status = @proposal.status_was
        flash[:alert] = "Unable to set status to Tabled unless in 'Pre-Voting' or 'Review' state"
        format.html { render action: "show" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end
end
