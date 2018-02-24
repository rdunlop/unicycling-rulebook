require 'spec_helper'

describe InformCommitteeMembers do
  # before { FactoryBot.create(:rulebook, :test_schema) }

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
      let(:user) { FactoryBot.create(:user, no_emails: true) }
      let(:other_user) { FactoryBot.create(:user, no_emails: true) }

      it "should send NO e-mail" do
        ActionMailer::Base.deliveries.clear
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end
    end

    context "with user who is not yet confirmed" do
      let(:user) { FactoryBot.create(:user, no_emails: true) }
      let(:other_user) { FactoryBot.create(:user, confirmed_at: nil) }

      it "should send NO e-mail" do
        ActionMailer::Base.deliveries.clear
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end
    end

    context "with other member who is no-email" do
      let(:other_user) { FactoryBot.create(:user, no_emails: true) }

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
      let(:other_committee_member) { FactoryBot.create(:committee_member, :admin, committee: committee, user: other_user) }

      it "informs the committee-admin" do
        ActionMailer::Base.deliveries.clear
        do_action
        expect(ActionMailer::Base.deliveries.first.bcc).to eq([other_user.email])
      end
    end
  end

  let(:user) { FactoryBot.create(:user) }
  let!(:committee_member) { FactoryBot.create(:committee_member, committee: committee, user: user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:other_committee_member) { FactoryBot.create(:committee_member, committee: committee, user: other_user) }

  context "with a committee member" do
    let(:comment) { FactoryBot.create(:comment, user: user) }
    let(:committee) { comment.discussion.committee }
    let!(:other_committee_member) { FactoryBot.create(:committee_member, committee: comment.discussion.committee, user: other_user) }
    let(:do_action) { described_class.comment_added(comment) }

    it_should_behave_like "only inform members based on no_email flag"
  end

  context "with a submitted proposal" do
    let(:proposal) { FactoryBot.create(:proposal, :submitted) }
    let(:discussion) { FactoryBot.create(:discussion, proposal: proposal) }
    let(:comment) { FactoryBot.create(:comment, discussion: discussion, user: user) }
    let(:committee) { discussion.committee }
    let(:do_action) { described_class.comment_added(comment) }

    it_should_behave_like "only email admins for submitted proposals"
  end

  context "with a committee member2" do
    let(:proposal) { FactoryBot.create(:proposal, :review) }
    let(:revision) { FactoryBot.create(:revision, proposal: proposal, user: user) }
    let(:committee) { revision.proposal.committee }
    let(:do_action) { described_class.proposal_revised(revision) }

    it_should_behave_like "only inform members based on no_email flag"
  end

  context "with a submitted proposal" do
    let(:proposal) { FactoryBot.create(:proposal, :submitted) }
    let(:revision) { FactoryBot.create(:revision, proposal: proposal, user: user) }
    let(:committee) { revision.proposal.committee }
    let(:do_action) { described_class.proposal_revised(revision) }

    it_should_behave_like "only email admins for submitted proposals"
  end

  context "when votes have been submitted" do
    let(:proposal) { FactoryBot.create(:proposal, :submitted) }
    let(:committee) { proposal.committee }
    let!(:vote) { FactoryBot.create(:vote, proposal: proposal, user: user) }
    let(:do_action) { described_class.vote_submitted(vote) }

    it "should not send e-mail to people who have voted" do
      ActionMailer::Base.deliveries.clear
      do_action
      expect(ActionMailer::Base.deliveries.first.bcc).to eq([other_user.email])
    end

    context "when other member is non-voting" do
      let!(:other_committee_member) { FactoryBot.create(:committee_member, committee: committee, user: other_user, voting: false) }

      it "should not send e-mail to people who are not voting members" do
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end
    end
  end
end
