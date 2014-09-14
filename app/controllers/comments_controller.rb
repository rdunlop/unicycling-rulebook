class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :discussion
  load_and_authorize_resource :comment, :through => :discussion

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.discussion = @discussion
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        UserMailer.proposal_comment_added(@discussion.proposal, @comment, @comment.user).deliver
        format.html { redirect_to @comment.proposal, notice: 'Comment was successfully created.' }
        format.json { render json: @comment.proposal, status: :created, location: @comment.proposal }
      else
        format.html { render "proposals/show" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
end
