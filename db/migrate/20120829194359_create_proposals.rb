class CreateProposals < ActiveRecord::Migration[4.2]
  def change
    create_table :proposals do |t|
      t.integer :committee_id
      t.string :status
      t.datetime :submit_date
      t.datetime :review_start_date
      t.datetime :review_end_date
      t.datetime :vote_start_date
      t.datetime :vote_end_date
      t.datetime :tabled_date
      t.boolean :transition_straight_to_vote
      t.integer :owner_id
      t.text :summary
      t.text :title

      t.timestamps
    end
  end
end
