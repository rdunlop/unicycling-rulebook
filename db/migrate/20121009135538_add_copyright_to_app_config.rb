class AddCopyrightToAppConfig < ActiveRecord::Migration
  def change
    add_column :app_configs, :copyright, :string
  end
end
