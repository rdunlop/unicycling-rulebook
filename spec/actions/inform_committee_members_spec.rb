require 'spec_helper'

describe InformCommitteeMembers do

  shared_examples_for "only inform members based on no_email flag" do
    it "creates an e-mail" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "only informs the other user" do
      ActionMailer::Base.deliveries.clear
      do_action
      expect(ActionMailer::Base.deliveries.first.bcc).to eq([other_user.email])
    end

    context "with user with no_emails set" do
      let(:user) { FactoryGirl.create(:user, no_emails: true) }
      let(:other_user) { FactoryGirl.create(:user, no_emails: true) }

      it "should send NO e-mail" do
        ActionMailer::Base.deliveries.clear
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end

    end

    context "with other member who is no-email" do
      let(:other_user) { FactoryGirl.create(:user, no_emails: true) }

      it "should send NO email" do
        ActionMailer::Base.deliveries.clear
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end
    end
  end

  shared_examples_for "only email admins for submitted proposals" do
    it "sends NO email to other user" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end

    context "when the other user is a committee admin" do
      let(:other_committee_member) { FactoryGirl.create(:committee_member, :admin, committee: committee, user: other_user) }

      it "informs the committee-admin" do
        ActionMailer::Base.deliveries.clear
        do_action
        expect(ActionMailer::Base.deliveries.first.bcc).to eq([other_user.email])
      end
    end
  end

  let(:user) { FactoryGirl.create(:user) }
  let!(:committee_member) { FactoryGirl.create(:committee_member, committee: committee, user: user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let!(:other_committee_member) { FactoryGirl.create(:committee_member, committee: committee, user: other_user) }

  context "with a committee member" do
    let(:comment) { FactoryGirl.create(:comment, user: user) }
    let(:committee) { comment.discussion.committee }
    let!(:other_committee_member) { FactoryGirl.create(:committee_member, committee: comment.discussion.committee, user: other_user) }
    let(:do_action) { described_class.comment_added(comment) }

    it_should_behave_like "only inform members based on no_email flag"
  end

  context "with a submitted proposal" do
    let(:proposal) { FactoryGirl.create(:proposal, :submitted) }
    let(:discussion) { FactoryGirl.create(:discussion, proposal: proposal) }
    let(:comment) { FactoryGirl.create(:comment, discussion: discussion, user: user) }
    let(:committee) { discussion.committee }
    let(:do_action) { described_class.comment_added(comment) }

    it_should_behave_like "only email admins for submitted proposals"
  end


  context "with a committee member2" do
    let(:proposal) { FactoryGirl.create(:proposal, :review) }
    let(:revision) { FactoryGirl.create(:revision, proposal: proposal, user: user) }
    let(:committee) { revision.proposal.committee }
    let(:do_action) { described_class.proposal_revised(revision) }

    it_should_behave_like "only inform members based on no_email flag"
  end

  context "with a submitted proposal" do
    let(:proposal) { FactoryGirl.create(:proposal, :submitted) }
    let(:revision) { FactoryGirl.create(:revision, proposal: proposal, user: user) }
    let(:committee) { revision.proposal.committee }
    let(:do_action) { described_class.proposal_revised(revision) }

    it_should_behave_like "only email admins for submitted proposals"
  end
end
