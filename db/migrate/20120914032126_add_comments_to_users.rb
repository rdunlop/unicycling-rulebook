class AddCommentsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :comments, :text
  end
end
