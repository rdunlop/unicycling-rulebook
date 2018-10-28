class AddAdminToCommitteeMemberTable < ActiveRecord::Migration[4.2]
  def change
    add_column :committee_members, :admin, :boolean, default: false
  end
end
