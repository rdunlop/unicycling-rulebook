class CreateVotes < ActiveRecord::Migration[4.2]
  def change
    create_table :votes do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.string :vote

      t.timestamps
    end
  end
end
