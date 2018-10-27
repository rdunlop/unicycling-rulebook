class AddCommentToVote < ActiveRecord::Migration[4.2]
  def change
    add_column :votes, :comment, :text
  end
end
