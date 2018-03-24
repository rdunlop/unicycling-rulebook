require 'spec_helper'

describe ProposalCreator do
  let(:committee) { FactoryBot.create(:committee) }
  let(:discussion) { FactoryBot.create(:discussion, committee: committee) }
  let(:user) { FactoryBot.create(:user) }
  # let!(:member) { FactoryBot.create(:committee_member, committee: committee, user: user) }

  let(:new_proposal) { committee.proposals.build(title: "Hello") }
  let(:new_revision) { new_proposal.revisions.build(body: "The proposal") }

  describe "when a discussion already exists" do
    let(:do_action) { described_class.new(new_proposal, new_revision, discussion, user).perform }
    it "does not create a new discussion" do
      discussion
      expect { do_action }.not_to change(Discussion, :count)
    end

    it "sets the discussion's proposal" do
      do_action
      expect(discussion.proposal).not_to be_nil
    end
  end
end
