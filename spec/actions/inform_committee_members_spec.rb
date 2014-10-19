require 'spec_helper'

describe InformCommitteeMembers do

  context "with a committee member" do
    let(:user) { FactoryGirl.create(:user) }
    let(:comment) { FactoryGirl.create(:comment) }
    let!(:committee_member) { FactoryGirl.create(:committee_member, committee: comment.discussion.committee, user: user) }
    let(:do_action) { described_class.comment_added(comment) }

    it "creates an e-mail" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    context "with user with no_emails set" do
      let(:user) { FactoryGirl.create(:user, no_emails: true) }

      it "should send NO e-mail" do
        ActionMailer::Base.deliveries.clear
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end

    end

    context "with another member who is no-email" do
      let(:user2) { FactoryGirl.create(:user, no_emails: true) }
      let!(:committee_member2) { FactoryGirl.create(:committee_member, committee: comment.discussion.committee, user: user2) }

      it "should only send to the normal user" do
        ActionMailer::Base.deliveries.clear
        expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(ActionMailer::Base.deliveries.first.bcc).to eq([user.email])
      end
    end
  end

end
