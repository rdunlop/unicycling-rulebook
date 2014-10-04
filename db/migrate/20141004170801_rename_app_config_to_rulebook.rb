class RenameAppConfigToRulebook < ActiveRecord::Migration
  def change
    rename_table :app_configs, :rulebooks
  end
end
