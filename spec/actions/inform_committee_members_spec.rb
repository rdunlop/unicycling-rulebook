require 'spec_helper'

describe InformCommitteeMembers do

  shared_examples_for "only inform members based on no_email flag" do
  end

  context "with a committee member" do
    let(:user) { FactoryGirl.create(:user) }
    let(:comment) { FactoryGirl.create(:comment, user: user) }
    let!(:committee_member) { FactoryGirl.create(:committee_member, committee: comment.discussion.committee, user: user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let!(:other_committee_member) { FactoryGirl.create(:committee_member, committee: comment.discussion.committee, user: other_user) }
    let(:do_action) { described_class.comment_added(comment) }

    it "creates an e-mail" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "only informs the non-writers" do
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

  context "with a committee member2" do
    let(:user) { FactoryGirl.create(:user) }
    let(:proposal) { FactoryGirl.create(:proposal, :review) }
    let(:revision) { FactoryGirl.create(:revision, proposal: proposal, user: user) }
    let!(:committee_member) { FactoryGirl.create(:committee_member, committee: revision.proposal.committee, user: user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let!(:other_committee_member) { FactoryGirl.create(:committee_member, committee: revision.proposal.committee, user: other_user) }
    let(:do_action) { described_class.proposal_revised(revision) }

    # Refactor this into a common-example pattern:
    it "creates an e-mail" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "only informs the non-writers" do
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

  context "with a submitted proposal" do
    let(:user) { FactoryGirl.create(:user) }
    let(:proposal) { FactoryGirl.create(:proposal, :submitted) }
    let(:revision) { FactoryGirl.create(:revision, proposal: proposal, user: user) }
    let!(:committee_member) { FactoryGirl.create(:committee_member, committee: revision.proposal.committee, user: user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let!(:other_committee_member) { FactoryGirl.create(:committee_member, committee: revision.proposal.committee, user: other_user) }
    let(:do_action) { described_class.proposal_revised(revision) }

    it "sends NO email to other user" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end

    context "when the other user is a committee admin" do
      let(:other_committee_member) { FactoryGirl.create(:committee_member, :admin, committee: revision.proposal.committee, user: other_user) }

      it "informs the committee-admin" do
        ActionMailer::Base.deliveries.clear
        do_action
        expect(ActionMailer::Base.deliveries.first.bcc).to eq([other_user.email])
      end
    end
  end
end
