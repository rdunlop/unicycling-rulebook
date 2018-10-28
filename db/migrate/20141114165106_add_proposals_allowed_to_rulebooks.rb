class AddProposalsAllowedToRulebooks < ActiveRecord::Migration[4.2]
  def change
    add_column :rulebooks, :proposals_allowed, :boolean, default: true, null: false
  end
end
