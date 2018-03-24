require "spec_helper"

describe CommitteeMemberPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:committee_admin) { FactoryBot.create(:user) }

  before do
    FactoryBot.create(:committee_member, :admin, committee: committee, user: committee_admin)
  end

  let(:subject) { described_class }
  let(:committee) { FactoryBot.create :committee }
  let(:committee_member) { FactoryBot.create :committee_member, committee: committee }

  permissions :show?, :update? do
    it { expect(subject).to permit(committee_admin, committee_member) }
  end

  permissions :show?, :edit?, :create?, :update?, :destroy? do
    it { expect(subject).not_to permit(user, committee_member) }
  end

  # allowed for admins
  permissions :show?, :edit?, :create?, :update?, :destroy? do
    it { expect(subject).to permit(admin, committee_member) }
  end
end
