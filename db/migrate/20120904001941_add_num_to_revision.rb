class AddNumToRevision < ActiveRecord::Migration[4.2]
  def change
    add_column :revisions, :num, :integer
  end
end
