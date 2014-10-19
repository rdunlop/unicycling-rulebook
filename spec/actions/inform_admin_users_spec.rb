require 'spec_helper'

describe InformAdminUsers do
  let!(:user) { FactoryGirl.create(:user) }

  context "with NO admin user" do
    let(:do_action) { described_class.new_applicant(user) }

    it "creates an e-mail" do
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
  end

end
