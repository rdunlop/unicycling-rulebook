require "spec_helper"

describe CommitteePolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin_user) }

  let(:subject) { described_class }
  let(:committee) { FactoryBot.create :committee }

  permissions :show? do
    it { expect(subject).to permit(user, committee) }

    context "when the committee is private" do
      let(:committee) { FactoryBot.create :committee, private: true }

      it { expect(subject).not_to permit(user, committee) }

      context "when I'm a member of the committee" do
        let!(:committee_member) do
          FactoryBot.create(:committee_member, user: user, committee: committee)
        end

        it { expect(subject).to permit(user, committee) }
      end
    end
  end

  permissions :create?, :update?, :destroy? do
    it { expect(subject).not_to permit(user, committee) }
  end

  # allowed for admins
  permissions :show?, :create?, :update?, :destroy? do
    it { expect(subject).to permit(admin, committee) }
  end
end
