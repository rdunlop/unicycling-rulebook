require "spec_helper"

describe VotePolicy do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }

  subject { described_class }

  permissions :edit?, :destroy? do
    it "cannot be modified by a regular user" do
      expect(subject).not_to permit(user)
    end

    it "can be modified by admin users" do
      expect(subject).to permit(admin)
    end
  end
end
