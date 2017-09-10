# == Schema Information
#
# Table name: discussions
#
#  id           :integer          not null, primary key
#  proposal_id  :integer
#  title        :string(255)
#  status       :string(255)
#  owner_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  committee_id :integer
#  body         :text
#

class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_committee, only: %i[new create]
  before_action :set_committee_breadcrumb, only: %i[new create]
  before_action :load_discussion, only: %i[show close]

  # GET /discussions/1
  def show
    authorize @discussion
    @comment = @discussion.comments.new

    set_committee_breadcrumb(@discussion.committee)
    add_breadcrumb @discussion.title

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /committees/1/discussions/new
  def new
    @discussion = @committee.discussions.new
    authorize @discussion
    add_breadcrumb "New Discussion"
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /committees/1/discussions/
  def create
    load_new_discussion
    authorize @discussion
    respond_to do |format|
      if @discussion.save
        InformCommitteeMembers.discussion_created(@discussion)
        format.html { redirect_to [@discussion], notice: 'Discussion was successfully created.' }
      else
        flash.now[:alert] = "Unable to create discussion"
        format.html { render action: "new" }
      end
    end
  end

  def close
    authorize @discussion
    respond_to do |format|
      if @discussion.close
        format.html { redirect_to @discussion, notice: "Discussion has been closed." }
      else
        @comment = @discussion.comments.new
        flash.now[:alert] = "Unable to close this discussion"
        format.html { render action: "show" }
      end
    end
  end

  private

  def load_committee
    @committee = Committee.find(params[:committee_id])
  end

  def load_discussion
    @discussion = Discussion.find(params[:id])
  end

  def load_new_discussion
    @discussion = Discussion.new(discussion_params)
    @discussion.committee = @committee
    @discussion.owner = current_user
    @discussion.status = "active"
  end

  def discussion_params
    params.require(:discussion).permit(:title, :body)
  end
end
