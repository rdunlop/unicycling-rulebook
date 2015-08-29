class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :discussion
  load_and_authorize_resource :comment, through: :discussion

  # POST /comments
  # POST /comments.json
  def create
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        InformCommitteeMembers.comment_added(@comment)

        format.html { redirect_to @comment.discussion, notice: 'Comment was successfully created.' }
      else
        format.html { render "discussions/show" }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
