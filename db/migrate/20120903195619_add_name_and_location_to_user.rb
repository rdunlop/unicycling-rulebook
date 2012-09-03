class AddNameAndLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :location, :string
  end
end
