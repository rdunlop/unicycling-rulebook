class CreateCommittees < ActiveRecord::Migration[4.2]
  def change
    create_table :committees do |t|
      t.string :name

      t.timestamps
    end
  end
end
