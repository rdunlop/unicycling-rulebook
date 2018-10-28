class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
