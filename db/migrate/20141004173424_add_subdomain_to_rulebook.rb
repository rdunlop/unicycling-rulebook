class AddSubdomainToRulebook < ActiveRecord::Migration
  def change
    add_column :rulebooks, :subdomain, :string

    add_index :rulebooks, :subdomain, unique: true
  end
end
