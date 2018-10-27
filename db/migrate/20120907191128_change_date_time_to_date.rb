class ChangeDateTimeToDate < ActiveRecord::Migration[4.2]
  def change
    change_column :proposals, :submit_date, :date
    change_column :proposals, :review_start_date, :date
    change_column :proposals, :review_end_date, :date
    change_column :proposals, :vote_start_date, :date
    change_column :proposals, :vote_end_date, :date
    change_column :proposals, :tabled_date, :date
  end
end
