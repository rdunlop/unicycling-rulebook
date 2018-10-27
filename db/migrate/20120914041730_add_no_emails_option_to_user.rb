class AddNoEmailsOptionToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :no_emails, :boolean
  end
end
