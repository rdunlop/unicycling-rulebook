class CreateDiscussion < ActiveRecord::Migration[4.2]
  def change
    create_table :discussions do |t|
      t.integer :proposal_id
      t.string :title
      t.string :status
      t.integer :owner_id
      t.timestamps
    end

    add_column :comments, :discussion_id, :integer
  end
end
