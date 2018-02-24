class AddProposalsAllowedToRulebooks < ActiveRecord::Migration
  def change
    add_column :rulebooks, :proposals_allowed, :boolean, default: true, null: false
  end
end
