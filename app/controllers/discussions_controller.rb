class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :committee, except: :show
  before_action :load_new_discussion, only: :create
  load_and_authorize_resource through: :committee, except: :show
  load_and_authorize_resource only: :show

  # GET /discussions/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /committees/1/discussions/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /committees/1/discussions/
  def create
    respond_to do |format|
      if @discussion.save
        format.html { redirect_to [@discussion], notice: 'Discussion was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  private

  def load_new_discussion
    @discussion = Discussion.new(params[:discussion])
    @discussion.committee = @committee
    @discussion.owner = current_user
    @discussion.status = "active"
  end
end
