class AddMailMessageIdToProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :proposals, :mail_messageid, :string
  end
end
