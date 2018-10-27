class DropSummaryFromProposal < ActiveRecord::Migration[4.2]
  def change
    remove_column :proposals, :summary
  end
end
