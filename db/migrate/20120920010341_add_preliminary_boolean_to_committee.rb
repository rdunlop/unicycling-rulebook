class AddPreliminaryBooleanToCommittee < ActiveRecord::Migration
  def change
    add_column :committees, :preliminary, :boolean
  end
end
