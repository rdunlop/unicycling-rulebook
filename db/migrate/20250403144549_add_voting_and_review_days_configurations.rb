class AddVotingAndReviewDaysConfigurations < ActiveRecord::Migration[7.1]
  def change
    add_column :rulebooks, :voting_days, :integer, default: 5, null: false
    add_column :rulebooks, :review_days, :integer, default: 5, null: false
  end
end
