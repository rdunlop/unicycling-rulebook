class DropSummaryFromProposal < ActiveRecord::Migration
  def change
    remove_column :proposals, :summary
  end
end
