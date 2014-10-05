class AddUpgradeCodeToRulebook < ActiveRecord::Migration
  def change
    add_column :rulebooks, :admin_upgrade_code, :string
  end
end
