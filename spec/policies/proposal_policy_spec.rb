require "spec_helper"

describe ProposalPolicy do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }

  let(:subject) { described_class }
  let(:committee) { FactoryGirl.create :committee }

  permissions :index? do
    it { expect(subject).to permit(user, Proposal) }
  end

  describe "with submitted proposal" do
    let(:committee) { FactoryGirl.create(:committee) }
    let!(:submitted_proposal) { FactoryGirl.create(:proposal, :submitted, committee: committee) }

    permissions :show? do
      it { is_expected.not_to permit(user, submitted_proposal) }

      describe "as committee admin" do
        before do
          FactoryGirl.create(:committee_member, committee: committee, user: user, admin: true)
        end

        it { is_expected.to permit(user, submitted_proposal) }
      end

      describe "as owner of submitted proposal" do
        let(:user) { submitted_proposal.owner }

        it { is_expected.to permit(user, submitted_proposal) }
      end
    end
  end

  describe "with a 'review' proposal" do
    let(:committee) { FactoryGirl.create(:committee) }
    let!(:review_proposal) { FactoryGirl.create(:proposal, :review, committee: committee) }

    permissions :show? do
      it { is_expected.to permit(user, review_proposal) }
    end
  end

  describe "when not logged in" do
    permissions :show? do
      describe "with a set-aside proposal" do
        let(:proposal) { FactoryGirl.build_stubbed :proposal, :set_aside }
        it { is_expected.to permit(nil, proposal) }
      end

      describe "with a failed proposal" do
        let(:proposal) { FactoryGirl.build_stubbed :proposal, :failed }
        it { is_expected.to permit(nil, proposal) }
      end
    end
  end
end
