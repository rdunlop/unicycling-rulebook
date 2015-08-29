require "spec_helper"

describe CommitteePolicy do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }

  let(:subject) { described_class }
  let(:committee) { FactoryGirl.create :committee }

  permissions :show? do
    it { expect(subject).to permit(user, committee) }
  end

  permissions :create?, :update?, :destroy? do
    it { expect(subject).not_to permit(user, committee) }
  end

  # allowed for admins
  permissions :show?, :create?, :update?, :destroy? do
    it { expect(subject).to permit(admin, committee) }
  end
end
