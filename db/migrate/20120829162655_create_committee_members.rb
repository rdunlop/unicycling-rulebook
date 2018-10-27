class CreateCommitteeMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :committee_members do |t|
      t.integer :committee_id
      t.integer :user_id
      t.boolean :voting

      t.timestamps
    end
  end
end
