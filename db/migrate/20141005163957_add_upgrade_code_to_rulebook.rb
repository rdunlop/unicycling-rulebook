class AddUpgradeCodeToRulebook < ActiveRecord::Migration[4.2]
  def change
    add_column :rulebooks, :admin_upgrade_code, :string
  end
end
