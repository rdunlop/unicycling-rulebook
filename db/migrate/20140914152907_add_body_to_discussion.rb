class AddBodyToDiscussion < ActiveRecord::Migration[4.2]
  def change
    add_column :discussions, :body, :text
  end
end
