class CreateAppConfigs < ActiveRecord::Migration[4.2]
  def change
    create_table :app_configs do |t|
      t.string :rulebook_name
      t.string :front_page
      t.string :faq

      t.timestamps
    end
  end
end
