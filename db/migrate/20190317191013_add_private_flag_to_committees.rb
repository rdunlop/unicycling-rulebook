class AddPrivateFlagToCommittees < ActiveRecord::Migration[5.2]
  def change
    add_column :committees, :private, :boolean, default: false, null: false
  end
end
