class AddEditorToCommitteeMember < ActiveRecord::Migration
  def change
    add_column :committee_members, :editor, :boolean, :default => false
  end
end
