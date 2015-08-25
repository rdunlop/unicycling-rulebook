class AddAdminToCommitteeMemberTable < ActiveRecord::Migration
  def change
    add_column :committee_members, :admin, :boolean, default: false
  end
end
