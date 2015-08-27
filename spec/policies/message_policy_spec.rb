require "spec_helper"

describe MessagePolicy do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }

  subject { described_class }

  permissions :create? do
    it "can be created by an admin" do
      expect(subject).to permit(admin)
    end
    it "cannot be created by normal users" do
      expect(subject).not_to permit(user)
    end
  end
end
