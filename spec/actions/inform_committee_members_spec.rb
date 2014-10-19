require 'spec_helper'

describe InformCommitteeMembers do

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

end
