class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :discussion
  load_and_authorize_resource :comment, :through => :discussion

  # POST /comments
  # POST /comments.json
  def create
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        UserMailer.discussion_comment_added(@discussion, @comment, @comment.user).deliver
        format.html { redirect_to @comment.discussion, notice: 'Comment was successfully created.' }
      else
        format.html { render "discussions/show" }
      end
    end
  end
end
