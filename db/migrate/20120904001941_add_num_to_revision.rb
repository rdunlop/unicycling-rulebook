class AddNumToRevision < ActiveRecord::Migration
  def change
    add_column :revisions, :num, :integer
  end
end
