require "spec_helper"

describe DiscussionPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:committee_admin) { FactoryBot.create(:user) }

  let(:subject) { described_class }
  let(:committee) { FactoryBot.create :committee }
  let(:private_committee) { FactoryBot.create :committee, private: true }
  let(:discussion) { FactoryBot.create(:discussion, committee: committee) }
  let(:private_discussion) { FactoryBot.create(:discussion, committee: private_committee) }
  let!(:committee_member) { FactoryBot.create(:committee_member, :admin, user: committee_admin, committee: committee) }

  permissions :show? do
    context "when logged in" do
      it { expect(subject).to permit(user, discussion) }
      it { expect(subject).not_to permit(user, private_discussion) }

      context "when I'm a member of the private committee" do
        let!(:committee_member) do
          FactoryBot.create(:committee_member, user: user, committee: private_committee)
        end
        it { expect(subject).to permit(user, private_discussion) }
      end
    end

    context "when not logged in" do
      it { expect(subject).to permit(user, discussion) }
      it { expect(subject).not_to permit(user, private_discussion) }
    end
  end

  permissions :create? do
    it { expect(subject).not_to permit(admin, discussion) }
    it { expect(subject).to permit(committee_admin, discussion) }
  end

  permissions :close? do
    context "when discussion is closed" do
      before do
        discussion.update(status: "closed")
      end

      it { expect(subject).not_to permit(admin, discussion) }
    end

    it { expect(subject).not_to permit(user, discussion) }
    it { expect(subject).to permit(admin, discussion) }
    it { expect(subject).to permit(committee_admin, discussion) }
  end
end
