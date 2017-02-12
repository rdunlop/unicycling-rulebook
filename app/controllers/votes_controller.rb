# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  user_id     :integer
#  vote        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  comment     :text
#

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_proposal
  before_action :load_vote, only: [:edit, :update, :destroy]
  before_action :authorize_vote, only: [:edit, :update, :destroy]

  # GET /proposals/:proposal_id/votes
  def index
    authorize @proposal, :view_votes?
    @votes = @proposal.votes

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /proposals/:proposal_id/votes/new
  def new
    @vote = Vote.new
    @vote.proposal = @proposal
    authorize @vote

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /proposals/:proposal_id/votes/1/edit
  def edit
  end

  # POST /proposals/:proposal_id/votes
  def create
    @vote = Vote.new(vote_params)
    @vote.proposal = @proposal
    @vote.user = current_user
    authorize @vote

    respond_to do |format|
      if @vote.save
        InformCommitteeMembers.vote_submitted(@vote)
        format.html { redirect_to @proposal, notice: 'Vote was successfully created.' }
      else
        format.html { render "proposals/show" }
      end
    end
  end

  # PUT /proposals/:proposal_id/votes/1
  def update
    previous_value = @vote.vote

    respond_to do |format|
      if @vote.update_attributes(vote_params)
        format.html { redirect_to [@proposal, @vote], notice: 'Vote was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /proposals/:proposal_id/votes/1
  def destroy
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to proposal_url(@proposal) }
    end
  end

  private

  def authorize_vote
    authorize @vote
  end

  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def load_vote
    @vote = @proposal.votes.find(params[:id])
  end

  def vote_params
    params.require(:vote).permit(:vote, :comment)
  end
end
