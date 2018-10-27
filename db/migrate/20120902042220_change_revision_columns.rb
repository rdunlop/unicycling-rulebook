class ChangeRevisionColumns < ActiveRecord::Migration[4.2]
  def change
    rename_column :revisions, :changes, :change_description
  end
end
