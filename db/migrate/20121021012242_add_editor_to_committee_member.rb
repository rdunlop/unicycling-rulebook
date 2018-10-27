class AddEditorToCommitteeMember < ActiveRecord::Migration[4.2]
  def change
    add_column :committee_members, :editor, :boolean, default: false
  end
end
