class AddSubdomainToRulebook < ActiveRecord::Migration[4.2]
  def change
    add_column :rulebooks, :subdomain, :string

    add_index :rulebooks, :subdomain, unique: true
  end
end
