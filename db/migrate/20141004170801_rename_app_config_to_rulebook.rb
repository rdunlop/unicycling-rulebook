class RenameAppConfigToRulebook < ActiveRecord::Migration[4.2]
  def change
    rename_table :app_configs, :rulebooks
  end
end
