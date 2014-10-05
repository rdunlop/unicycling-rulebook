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

    context "With a committee member" do
      let(:committee_member) { FactoryGirl.create(:committee_member) }
      it { is_expected.not_to be_able_to(:read, committee_member) }
      it { is_expected.not_to be_able_to(:edit, committee_member) }
      it { is_expected.not_to be_able_to(:create, committee_member) }
      it { is_expected.not_to be_able_to(:destroy, committee_member) }
      it { is_expected.not_to be_able_to(:update, committee_member) }
    end

    context "with a committee" do
      let(:committee) { FactoryGirl.create :committee }
      it { is_expected.to be_able_to(:read, committee) }
      it { is_expected.not_to be_able_to(:edit, committee) }
      it { is_expected.not_to be_able_to(:create, committee) }
      it { is_expected.not_to be_able_to(:update, committee) }
      it { is_expected.not_to be_able_to(:destroy, committee) }
    end

    context "with a proposal" do
      let(:proposal) { FactoryGirl.create :proposal, :submitted }
      it { is_expected.not_to be_able_to(:set_review, proposal) }
    end

    context "with a vote" do
      let(:vote) { FactoryGirl.create :vote }
      it { is_expected.not_to be_able_to(:edit, vote) }
      it { is_expected.not_to be_able_to(:update, vote) }
      it { is_expected.not_to be_able_to(:destroy, vote) }
    end

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

  describe "as an admin user" do
    let(:user) { FactoryGirl.build_stubbed(:admin_user) }

    subject { @ability = Ability.new(user) }

    context "With a committee member" do
      let(:committee_member) { FactoryGirl.create(:committee_member) }
      it { is_expected.to be_able_to(:read, committee_member) }
      it { is_expected.to be_able_to(:edit, committee_member) }
      it { is_expected.to be_able_to(:create, committee_member) }
      it { is_expected.to be_able_to(:destroy, committee_member) }
      it { is_expected.to be_able_to(:update, committee_member) }
    end

    context "with a committee" do
      let(:committee) { FactoryGirl.create :committee }
      it { is_expected.to be_able_to(:read, committee) }
      it { is_expected.to be_able_to(:edit, committee) }
      it { is_expected.to be_able_to(:create, committee) }
      it { is_expected.to be_able_to(:update, committee) }
      it { is_expected.to be_able_to(:destroy, committee) }
    end

    context "with a proposal" do
      let(:proposal) { FactoryGirl.create :proposal, :submitted }
      it { is_expected.to be_able_to(:set_review, proposal) }
    end

    context "with a vote" do
      let(:vote) { FactoryGirl.create :vote }
      it { is_expected.to be_able_to(:edit, vote) }
      it { is_expected.to be_able_to(:update, vote) }
      it { is_expected.to be_able_to(:destroy, vote) }
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
