class SetBooleanDefaults < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :admin,              :boolean, default: false, null: false
    change_column :users, :no_emails,          :boolean, default: false, null: false
    change_column :committee_members, :voting, :boolean, default: true, null: false
    change_column :committee_members, :admin,  :boolean, default: false, null: false
    change_column :committee_members, :editor, :boolean, default: false, null: false
    change_column :committees, :preliminary,   :boolean, default: true, null: false
    change_column :proposals, :transition_straight_to_vote, :boolean, default: true, null: false
  end
end
