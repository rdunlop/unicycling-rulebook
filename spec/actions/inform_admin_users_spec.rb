require 'spec_helper'

describe InformAdminUsers do
  let!(:user) { FactoryGirl.create(:user) }
  # before { FactoryGirl.create(:rulebook, :test_schema) }

  context "with NO admin user" do
    let(:do_action) { described_class.new_applicant(user) }

    it "creates NO e-mail" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end
  end

  context "with an admin user" do
    let!(:admin_user) { FactoryGirl.create(:admin_user) }
    let(:do_action) { described_class.new_applicant(user) }

    it "creates an e-mail" do
      ActionMailer::Base.deliveries.clear
      expect { do_action }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    context "with an admin with no_emails set" do
      let(:admin_user2) { FactoryGirl.create(:admin_user, no_emails: true) }

      it "should only send to the normal admin" do
        ActionMailer::Base.deliveries.clear
        do_action
        expect(ActionMailer::Base.deliveries.first.bcc).to eq([admin_user.email])
      end
    end
  end

end
