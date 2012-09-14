class AddNoEmailsOptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :no_emails, :boolean
  end
end
