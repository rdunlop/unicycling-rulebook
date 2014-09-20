class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :committee, except: [:show, :close]
  before_action :load_new_discussion, only: :create
  load_and_authorize_resource through: :committee, except: [:show, :close]
  load_and_authorize_resource only: [:show, :close]

  # GET /discussions/1
  def show
    if can?(:create, Comment)
      @comment = @discussion.comments.new
    end

    add_breadcrumb @discussion.committee, committee_path(@discussion.committee)
    add_breadcrumb @discussion.title

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

  def close
    respond_to do |format|
      if @discussion.close
        format.html { redirect_to @discussion, notice: "Discussion has been closed." }
      else
        format.html { render action: "show" }
      end
    end
  end

  private

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
