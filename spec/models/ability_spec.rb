require "spec_helper"

xdescribe "Ability", type: :model do
  describe "as a normal user" do
    let(:user) { FactoryGirl.build_stubbed(:user) }

    subject { @ability = Ability.new(user) }

    it { is_expected.not_to be_able_to(:read, User.new) }
    it { is_expected.not_to be_able_to(:create, Committee) }

    context "with a proposal" do
      let(:proposal) { FactoryGirl.create :proposal, :submitted }
      it { is_expected.not_to be_able_to(:set_review, proposal) }
    end

    # Proposals
    describe "when the rulebook is configured for no proposals allowed" do
      let(:committee) { FactoryGirl.create(:committee) }
      let(:rulebook) { FactoryGirl.create(:rulebook, proposals_allowed: false) }
      before { allow(Rulebook).to receive(:current_rulebook).and_return(rulebook) }

      it { is_expected.not_to be_able_to(:create_proposal, committee) }
    end
  end

  describe "as a committee admin" do
    let(:user) { FactoryGirl.build_stubbed(:user) }
    let(:committee_member) { FactoryGirl.create(:committee_member, user: user, admin: true, voting: false) }
    let(:committee) { committee_member.committee }
    subject { @ability = Ability.new(user) }

    specify { is_expected.not_to be_able_to(:create_proposal, committee) }

    describe "when also voting member" do
      before { committee_member.update_attribute(:voting, true) }

      specify { is_expected.to be_able_to(:create_proposal, committee) }
    end

    describe "when proposals are not allowed" do
      let(:rulebook) { FactoryGirl.create(:rulebook, proposals_allowed: false) }
      before { allow(Rulebook).to receive(:current_rulebook).and_return(rulebook) }

      specify { is_expected.to_not be_able_to(:create_proposal, committee) }

      describe "as a voting member" do
        before { committee_member.update_attribute(:voting, true) }

        specify { is_expected.to be_able_to(:create_proposal, committee) }
      end
    end
  end

  describe "as an admin user" do
    let(:user) { FactoryGirl.build_stubbed(:admin_user) }

    subject { @ability = Ability.new(user) }

    context "with a proposal" do
      let(:proposal) { FactoryGirl.create :proposal, :submitted }
      it { is_expected.to be_able_to(:set_review, proposal) }
    end
  end
end
