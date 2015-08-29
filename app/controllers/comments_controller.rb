class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_discussion

  # POST /comments
  def create
    @comment = @discussion.comments.new(comment_params)
    authorize @comment
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

  def load_discussion
    @discussion = Discussion.find(params[:discussion_id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
