class CreateRevisions < ActiveRecord::Migration[4.2]
  def change
    create_table :revisions do |t|
      t.integer :proposal_id
      t.text :body
      t.text :background
      t.text :references
      t.text :changes
      t.integer :user_id

      t.timestamps
    end
  end
end
