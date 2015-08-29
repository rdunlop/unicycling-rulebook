require "spec_helper"

describe CommitteeMemberPolicy do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:committee_admin) { FactoryGirl.create(:user) }

  before do
    FactoryGirl.create(:committee_member, :admin, committee: committee, user: committee_admin)
  end

  let(:subject) { described_class }
  let(:committee) { FactoryGirl.create :committee }
  let(:committee_member) { FactoryGirl.create :committee_member, committee: committee }

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
