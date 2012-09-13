class VotesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :proposal
  load_and_authorize_resource :vote, :through => :proposal

  # GET /votes
  # GET /votes.json
  def index
    @votes = @proposal.votes

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@proposal, @vote] }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])
    @vote.proposal = @proposal
    @vote.user = current_user
    @comment = @proposal.comments.new

    respond_to do |format|
      if @vote.save
        UserMailer.vote_submitted(@vote).deliver
        format.html { redirect_to @proposal, notice: 'Vote was successfully created.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render "proposals/show" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    previous_value = @vote.vote

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        UserMailer.vote_changed(@vote.proposal, current_user, previous_value, @vote.vote).deliver
        format.html { redirect_to [@proposal, @vote], notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to proposal_url(@proposal) }
      format.json { head :no_content }
    end
  end
end
