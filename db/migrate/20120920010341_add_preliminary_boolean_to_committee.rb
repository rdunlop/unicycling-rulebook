class AddPreliminaryBooleanToCommittee < ActiveRecord::Migration[4.2]
  def change
    add_column :committees, :preliminary, :boolean
  end
end
