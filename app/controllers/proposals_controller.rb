# == Schema Information
#
# Table name: proposals
#
#  id                          :integer          not null, primary key
#  committee_id                :integer
#  status                      :string(255)
#  submit_date                 :date
#  review_start_date           :date
#  review_end_date             :date
#  vote_start_date             :date
#  vote_end_date               :date
#  tabled_date                 :date
#  transition_straight_to_vote :boolean          default(TRUE), not null
#  owner_id                    :integer
#  title                       :text
#  created_at                  :datetime
#  updated_at                  :datetime
#  mail_messageid              :string(255)
#

class ProposalsController < ApplicationController
  before_action :authenticate_user!, except: %i[show passed]
  before_action :load_committee, only: %i[new create]
  before_action :set_committee_breadcrumb, only: %i[new create]
  before_action :load_and_authorize_proposal, only: %i[show edit update destroy]
  before_action :load_committees, only: %i[edit update]

  # GET /proposals/passed
  def passed
    authorize Proposal
    add_breadcrumb "Approved Proposals"
    # the non-preliminary ones go first
    @proposals = Proposal.select { |p| p.committee.preliminary == false and p.status == 'Passed' }
    @proposals += Proposal.select { |p| p.committee.preliminary == true and p.status == 'Passed' }

    respond_to do |format|
      format.html # passed.html.erb
    end
  end

  # GET /proposals/1
  def show
    set_proposal_breadcrumb

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /committees/1/proposals/new
  def new
    add_breadcrumb "New Proposal"
    authorize @committee, :create_proposal?

    @proposal = Proposal.new
    @revision = Revision.new
    @available_discussions = @committee.discussions.without_proposals
    @proposal_owner = current_user

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /proposals/1/edit
  def edit
    set_committee_breadcrumb(@proposal.committee)
    add_breadcrumb "Revise Proposal Dates & Status"
  end

  # POST /committees/2/proposals
  def create
    @proposal = Proposal.new(proposal_params)
    @proposal.committee = @committee
    @revision = @proposal.revisions.build(revision_params)

    @discussion = Discussion.find(params[:discussion_id]) if params[:discussion_id].present?
    @proposal.discussion = @discussion

    authorize @committee, :create_proposal?

    respond_to do |format|
      if ProposalCreator.new(@proposal, @revision, @discussion, current_user).perform
        InformAdminUsers.submit_proposal(@proposal)
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
      else
        add_breadcrumb "New Proposal"
        @proposal_owner = current_user
        @available_discussions = @committee.discussions.without_proposals
        format.html { render action: "new" }
      end
    end
  end

  # PUT /proposals/1
  def update
    respond_to do |format|
      if @proposal.update(update_params)
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
      else
        set_committee_breadcrumb(@proposal.committee)
        add_breadcrumb "Revise Proposal Dates & Status"
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /proposals/1
  def destroy
    committee = @proposal.committee
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to committee_path(committee) }
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

  def load_committees
    @committees = current_user.accessible_committees
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
