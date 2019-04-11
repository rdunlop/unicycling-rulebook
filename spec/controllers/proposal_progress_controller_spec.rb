require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ProposalProgressController, type: :controller do
  let(:committee) { FactoryBot.create(:committee) }
  before do
    @user = FactoryBot.create(:user)
    @admin_user = FactoryBot.create(:admin_user)
    sign_in @admin_user
    @cm = FactoryBot.create(:committee_member, committee: committee, user: @admin_user)
    @cm2 = FactoryBot.create(:committee_member, committee: committee, user: @user)
    request.env["HTTP_REFERER"] = root_url
  end

  # This should return the minimal set of attributes required to create a valid
  # Proposal. As you add validations to Proposal, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      title: "My Title",
      committee_id: committee.id
    }
  end

  describe "PUT set_voting" do
    it "changes the status to voting" do
      proposal = FactoryBot.create(:proposal, :with_admin, status: "Pre-Voting")

      put :set_voting, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Voting")
      expect(proposal.vote_start_date).to eq(Date.current)
      expect(proposal.vote_end_date - Date.current).to eq(7)
    end

    it "should not be allowed to change unless the status is Pre-Voting" do
      proposal = FactoryBot.create(:proposal, :with_admin, status: "Tabled")

      put :set_voting, params: { id: proposal.to_param }

      expect(response).to redirect_to(root_path)
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Tabled")
    end
    it "should send an e-mail" do
      proposal = FactoryBot.create(:proposal, :with_admin, status: "Pre-Voting")
      ActionMailer::Base.deliveries.clear

      put :set_voting, params: { id: proposal.to_param }
      num_deliveries = ActionMailer::Base.deliveries.size
      expect(num_deliveries).to eq(1)
    end
    describe "as a committee-admin for the same committee" do
      before(:each) do
        @proposal = FactoryBot.create(:proposal, :with_admin, status: "Pre-Voting")
        sign_out @admin_user
        cm = FactoryBot.create(:committee_member, committee: @proposal.committee, admin: true)
        @cm_admin_user = cm.user
        sign_in @cm_admin_user
      end
      it "should be able to set_voting" do
        put :set_voting, params: { id: @proposal.to_param }

        expect(response).to redirect_to(proposal_path(@proposal))
      end
    end
  end

  describe "PUT set_review" do
    before(:each) do
      @proposal = FactoryBot.create(:proposal, :with_admin, status: "Submitted")
      @revision = FactoryBot.create(:revision, proposal: @proposal)
    end

    it "changes the status to Review" do
      proposal = @proposal

      put :set_review, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Review")
      expect(proposal.review_start_date).to eq(Date.current)
      expect(proposal.review_end_date - Date.current).to eq(Proposal::REVIEW_DAYS)
    end
    it "should send an e-mail" do
      proposal = @proposal
      ActionMailer::Base.deliveries.clear

      put :set_review, params: { id: proposal.to_param }

      num_deliveries = ActionMailer::Base.deliveries.size
      expect(num_deliveries).to eq(1)
    end

    it "changes the status to Review from Tabled status" do
      proposal = @proposal

      put :set_review, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Review")
      expect(proposal.review_start_date).to eq(Date.current)
      expect(proposal.review_end_date - Date.current).to eq(Proposal::REVIEW_DAYS)
    end

    it "should not be allowed to change unless the status is Submitted" do
      @proposal.status = 'Pre-Voting'
      @proposal.save
      proposal = @proposal

      put :set_review, params: { id: proposal.to_param }

      expect(response).to redirect_to(root_path)
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Pre-Voting")
    end
    describe "as a committee-admin for the same committee" do
      before(:each) do
        sign_out @admin_user
        cm = FactoryBot.create(:committee_member, committee: @proposal.committee, admin: true)
        @cm_admin_user = cm.user
        sign_in @cm_admin_user
      end
      it "should be able to set_review" do
        put :set_review, params: { id: @proposal.to_param }

        expect(response).to redirect_to(proposal_path(@proposal))
      end
    end
    describe "as owner of a proposal" do
      before(:each) do
        sign_out @admin_user
        sign_in @proposal.owner
      end
      it "can put a tabled proposal into review" do
        @proposal.status = 'Tabled'
        @proposal.save
        proposal = @proposal

        put :set_review, params: { id: proposal.to_param }

        expect(response).to redirect_to(proposal_path(proposal))
        proposal.reload
        expect(proposal.status).to eq("Review")
      end
    end
  end

  describe "PUT set_pre_voting" do
    before(:each) do
      sign_out @admin_user
      sign_in @admin_user
    end

    it "changes the status to Pre-Voting" do
      proposal = FactoryBot.create(:proposal, status: "Voting")

      put :set_pre_voting, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Pre-Voting")
    end

    it "changes the status to Pre-Voting should remove any votes" do
      proposal = FactoryBot.create(:proposal, status: "Voting")
      FactoryBot.create(:vote, proposal: proposal)

      expect(proposal.votes.count).to eq(1)

      put :set_pre_voting, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Pre-Voting")
      expect(proposal.votes.count).to eq(0)
    end

    it "should not be allowed to change unless the status is Voting" do
      proposal = FactoryBot.create(:proposal, status: "Tabled")

      put :set_pre_voting, params: { id: proposal.to_param }

      expect(response).to redirect_to(root_path)
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Tabled")
    end
    describe "as a committee admin" do
      before(:each) do
        @proposal = FactoryBot.create(:proposal, status: "Voting")
        sign_out @admin_user
        cm = FactoryBot.create(:committee_member, committee: @proposal.committee, admin: true)
        @cm_admin_user = cm.user
        sign_in @cm_admin_user
      end
      it "can set pre voting" do
        put :set_pre_voting, params: { id: @proposal.to_param }

        expect(response).to redirect_to(proposal_path(@proposal))
        @proposal.reload
        expect(@proposal.status).to eq("Pre-Voting")
      end
    end
  end
  describe "PUT table" do
    before(:each) do
      sign_out @admin_user
      sign_in @admin_user
    end

    it "changes the status to Tabled from review" do
      proposal = FactoryBot.create(:proposal, status: "Review")

      put :table, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Tabled")
      proposal.tabled_date == Date.current
    end

    it "changes the status to Tabled from Pre-Voting" do
      proposal = FactoryBot.create(:proposal, status: "Pre-Voting")

      put :table, params: { id: proposal.to_param }

      expect(response).to redirect_to(proposal_path(proposal))
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Tabled")
    end
    it "should set the tabled_date" do
      proposal = FactoryBot.create(:proposal, status: "Pre-Voting")

      put :table, params: { id: proposal.to_param }

      proposal.reload
      expect(proposal.tabled_date).to eq(Date.current)
    end
    it "does not allow changing to Tabled from Voting" do
      proposal = FactoryBot.create(:proposal, status: "Voting")

      put :table, params: { id: proposal.to_param }

      expect(response).to redirect_to root_path
      proposal = Proposal.find(proposal.id)
      expect(proposal.status).to eq("Voting")
      expect(assigns(:proposal).status).to eq("Voting")
      expect(flash[:alert]).to eq("Unable to set status to Tabled unless in 'Pre-Voting' or 'Review' state")
    end
    describe "as proposal owner" do
      before(:each) do
        sign_out @admin_user
        sign_in @user
      end
      it "can table a Submitted proposal" do
        proposal = FactoryBot.create(:proposal, owner: @user, status: "Pre-Voting")

        put :table, params: { id: proposal.to_param }
        proposal.reload
        expect(proposal.status).to eq("Tabled")
      end
    end
  end
end
