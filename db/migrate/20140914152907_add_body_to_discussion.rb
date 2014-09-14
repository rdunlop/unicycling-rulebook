class AddBodyToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :body, :text
  end
end
