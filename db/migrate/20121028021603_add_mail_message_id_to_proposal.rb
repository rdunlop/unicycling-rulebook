class AddMailMessageIdToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :mail_messageid, :string
  end
end
