class ChangeAppConfigFieldsToTextArea < ActiveRecord::Migration
  def change
    change_column :app_configs, :front_page, :text
    change_column :app_configs, :faq, :text
  end
end
