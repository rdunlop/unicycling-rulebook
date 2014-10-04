require "cancan/matchers"
require "spec_helper"

describe "Ability", :type => :model do
  describe "as a normal user" do
    let(:user) { FactoryGirl.build_stubbed(:user) }

    subject { @ability = Ability.new(user) }

    it { is_expected.to be_able_to(:read, Proposal) }
    it { is_expected.not_to be_able_to(:read, User.new) }
    it { is_expected.not_to be_able_to(:create, Committee) }
    it { is_expected.not_to be_able_to(:read, CommitteeMember) }

    # Proposals
    describe "with submitted proposal" do
      let(:committee) { FactoryGirl.create(:committee) }
      let!(:submitted_proposal) { FactoryGirl.create(:proposal, :submitted, committee: committee) }

      it { is_expected.not_to be_able_to(:read, submitted_proposal) }

      describe "as committee admin" do
        before do
          FactoryGirl.create(:committee_member, committee: committee, user: user, admin: true)
        end

        it { is_expected.to be_able_to(:read, submitted_proposal) }
      end

      describe "as owner of submitted proposal" do
        let(:user) { submitted_proposal.owner }

        it { is_expected.to be_able_to(:read, submitted_proposal) }
      end
    end
    describe "with a 'review' proposal" do
      let(:committee) { FactoryGirl.create(:committee) }
      let!(:review_proposal) { FactoryGirl.create(:proposal, :review, committee: committee) }

      it { is_expected.to be_able_to(:read, review_proposal) }
    end
  end

  describe "when not logged in" do
    subject { @ability = Ability.new(nil) }

    describe "with a set-aside proposal" do
      let(:proposal) { FactoryGirl.build_stubbed :proposal, :set_aside }
      it { is_expected.to be_able_to(:read, proposal) }
    end

    describe "with a failed proposal" do
      let(:proposal) { FactoryGirl.build_stubbed :proposal, :failed }
      it { is_expected.to be_able_to(:read, proposal) }
    end
  end
end
