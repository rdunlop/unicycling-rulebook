class ChangeRevisionColumns < ActiveRecord::Migration
  def change
    rename_column :revisions, :changes, :change_description
  end
end
