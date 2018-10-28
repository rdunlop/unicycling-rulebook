class AddCopyrightToAppConfig < ActiveRecord::Migration[4.2]
  def change
    add_column :app_configs, :copyright, :string
  end
end
