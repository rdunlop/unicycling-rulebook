class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :discussion
  before_action :load_new_comment
  load_and_authorize_resource :comment, :through => :discussion

  # POST /comments
  # POST /comments.json
  def create
    respond_to do |format|
      if @comment.save
        UserMailer.discussion_comment_added(@discussion, @comment, @comment.user).deliver
        format.html { redirect_to @comment.discussion, notice: 'Comment was successfully created.' }
      else
        format.html { render "discussions/show" }
      end
    end
  end

  private

  def load_new_comment
    @comment = Comment.new(params[:comment])
    @comment.discussion = @discussion
    @comment.user = current_user
  end

end
