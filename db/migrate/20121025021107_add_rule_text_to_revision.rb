class AddRuleTextToRevision < ActiveRecord::Migration[4.2]
  class Revision < ActiveRecord::Base
  end
  class Proposal < ActiveRecord::Base
  end

  def up
    add_column :revisions, :rule_text, :text
    Revision.reset_column_information
    Proposal.all.each do |p|
      last_revision = p.latest_revision
      last_revision.rule_text = p.summary
      last_revision.save
    end
  end

  def down
    remove_column :revisions, :rule_text
  end
end
