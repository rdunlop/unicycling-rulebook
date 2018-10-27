class ChangeAppConfigFieldsToTextArea < ActiveRecord::Migration[4.2]
  def change
    change_column :app_configs, :front_page, :text
    change_column :app_configs, :faq, :text
  end
end
