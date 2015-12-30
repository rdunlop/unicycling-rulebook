# == Schema Information
#
# Table name: proposals
#
#  id                          :integer          not null, primary key
#  committee_id                :integer
#  status                      :string(255)
#  submit_date                 :date
#  review_start_date           :date
#  review_end_date             :date
#  vote_start_date             :date
#  vote_end_date               :date
#  tabled_date                 :date
#  transition_straight_to_vote :boolean          default(TRUE), not null
#  owner_id                    :integer
#  title                       :text
#  created_at                  :datetime
#  updated_at                  :datetime
#  mail_messageid              :string(255)
#

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

describe ProposalsController, type: :controller do
  let(:committee) { FactoryGirl.create(:committee) }
  before (:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
    sign_in @admin_user
    @cm = FactoryGirl.create(:committee_member, committee: committee, user: @admin_user)
    @cm2 = FactoryGirl.create(:committee_member, committee: committee, user: @user)
  end

  # This should return the minimal set of attributes required to create a valid
  # Proposal. As you add validations to Proposal, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        title: "My Title",
        committee_id: committee.id}
  end

  describe "GET passed" do
    before(:each) do
      com = FactoryGirl.create(:committee, preliminary: true)
      @preliminary_proposal = FactoryGirl.create(:proposal, status: 'Passed', committee: com)
      @proposal = FactoryGirl.create(:proposal, status: 'Passed')
      @other_proposal = FactoryGirl.create(:proposal, status: 'Failed')
    end
    it "assigns all proposals as @proposals" do
      get :passed, {}
      expect(assigns(:proposals)).to eq([@proposal, @preliminary_proposal])
    end
    it "can read the passed proposals when not signed in" do
      sign_out @admin_user
      get :passed, {}
      expect(assigns(:proposals)).to eq([@proposal, @preliminary_proposal])
    end
  end

  describe "GET show" do
    it "assigns the requested proposal as @proposal" do
      proposal = FactoryGirl.create(:proposal)
      get :show, {id: proposal.to_param}
      expect(assigns(:proposal)).to eq(proposal)
    end

    it "should be able to see 'Review' proposal when not logged in" do
      proposal = FactoryGirl.create(:proposal)
      sign_out @admin_user

      get :show, {id: proposal.to_param}

      expect(assigns(:proposal)).to eq(proposal)
    end
  end

  describe "GET new" do
    it "assigns a new proposal as @proposal" do
      get :new, {committee_id: committee.id}
      expect(assigns(:proposal)).to be_a_new(Proposal)
    end
    it "should set the owner to be the current-logged-in user" do
      get :new, {committee_id: committee.id}
      expect(assigns(:proposal_owner)).to eq(@admin_user)
    end
    it "should also have a @revision" do
      get :new, {committee_id: committee.id}
      expect(assigns(:revision)).to be_a_new(Revision)
    end
  end

  describe "GET edit" do
    it "assigns the requested proposal as @proposal" do
      proposal = FactoryGirl.create(:proposal, committee: committee)
      revision = FactoryGirl.create(:revision, proposal: proposal)
      get :edit, {id: proposal.to_param}
      expect(assigns(:proposal)).to eq(proposal)
      expect(assigns(:committees)).to eq([committee])
    end
    it "should not show committees that I am not an administrator of" do
      @other_committee = FactoryGirl.create(:committee)
      @other_committee_admin_user = FactoryGirl.create(:user)
      @cm3 = FactoryGirl.create(:committee_member, committee: @other_committee, user: @other_committee_admin_user, admin: true)
      proposal = FactoryGirl.create(:proposal, owner: @user, committee: @other_committee)
      revision = FactoryGirl.create(:revision, proposal: proposal)
      FactoryGirl.create(:committee)
      sign_out @admin_user
      sign_in @other_committee_admin_user
      get :edit, {id: proposal.to_param}
      expect(assigns(:proposal)).to eq(proposal)
      expect(assigns(:committees)).to eq([@other_committee])
    end
    it "as super-admin, should show all of the committees" do
      proposal = FactoryGirl.create(:proposal, committee: committee)
      revision = FactoryGirl.create(:revision, proposal: proposal)
      cm = FactoryGirl.create(:committee)
      get :edit, {id: proposal.to_param}
      expect(assigns(:committees)).to eq([committee, cm])
    end
    describe "as a committee-admin for the same committee" do
      before(:each) do
        @proposal = FactoryGirl.create(:proposal, status: "Review")
        sign_out @admin_user
        cm = FactoryGirl.create(:committee_member, committee: @proposal.committee, admin: true)
        @cm_admin_user = cm.user
        sign_in @cm_admin_user
      end
      it "should be able to get" do
        get :edit, {id: @proposal.to_param}
        expect(assigns(:proposal)).to eq(@proposal)
        expect(response).to render_template("edit")
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        @valid_revision_attributes = {
          background: "some background",
          body: "some body",
          references: "some references"}
      end
      it "creates a new Proposal" do
        expect {
          post :create, {committee_id: committee.id, proposal: valid_attributes, revision: @valid_revision_attributes}
        }.to change(Proposal, :count).by(1)
      end

      it "assigns a newly created proposal as @proposal" do
        post :create, {committee_id: committee.id, proposal: valid_attributes, revision: @valid_revision_attributes}
        expect(assigns(:proposal)).to be_a(Proposal)
        expect(assigns(:proposal)).to be_persisted
        expect(assigns(:revision)).to be_a(Revision)
        expect(assigns(:revision)).to be_persisted
      end

      it "redirects to the created proposal" do
        post :create, {committee_id: committee.id, proposal: valid_attributes, revision: @valid_revision_attributes}
        expect(response).to redirect_to(Proposal.last)
      end
      it "should increase revision count" do
        expect {
          post :create, {committee_id: committee.id, proposal: valid_attributes, revision: @valid_revision_attributes}
        }.to change(Revision, :count).by(1)
      end
      it "sets the submit_date when created" do
        post :create, {committee_id: committee.id, proposal: valid_attributes, revision: @valid_revision_attributes}
        expect(assigns(:proposal).submit_date).to eq(Date.today)
      end
      it "sends an e-mail when a new submission is created" do
        ActionMailer::Base.deliveries.clear
        post :create, {committee_id: committee.id, proposal: valid_attributes, revision: @valid_revision_attributes}
        num_deliveries = ActionMailer::Base.deliveries.size
        expect(num_deliveries).to eq(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved proposal as @proposal" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Proposal).to receive(:valid?).and_return(false)
        post :create, {committee_id: committee.id, proposal: {title: 'the prop'}, revision: {body: 'fake'}}
        expect(assigns(:proposal)).to be_a_new(Proposal)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Proposal).to receive(:valid?).and_return(false)
        post :create, {committee_id: committee.id, proposal: {title: 'the prop'}, revision: {body: 'fake'}}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested proposal" do
        proposal = FactoryGirl.create(:proposal)
        # Assuming there are no other proposals in the database, this
        # specifies that the Proposal created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Proposal).to receive(:update_attributes).with({})
        put :update, {id: proposal.to_param, proposal: {'these' => 'params'}}
      end
      it "can update all of the fields" do
        proposal = FactoryGirl.create(:proposal)
        review_start_date = Date.today
        review_end_date = Date.today.next_day(1)
        vote_start_date = Date.today.next_month(1)
        vote_end_date = Date.today.next_day(1).next_month(1)
        attrs = {   title: "some",
                    committee_id: proposal.committee,
                    status: "Review",
                    review_start_date: review_start_date,
                    review_end_date: review_end_date,
                    vote_start_date: vote_start_date,
                    vote_end_date: vote_end_date }

        put :update, {id: proposal.to_param, proposal: attrs}

        expect(response).to redirect_to(proposal)
        proposal.reload
        expect(proposal.review_start_date).to eq(review_start_date)
        expect(proposal.review_end_date).to eq(review_end_date)
        expect(proposal.vote_start_date).to eq(vote_start_date)
        expect(proposal.vote_end_date).to eq(vote_end_date)
        expect(proposal.status).to eq("Review")
        expect(proposal.title).to eq("some")
      end

      it "assigns the requested proposal as @proposal" do
        proposal = FactoryGirl.create(:proposal)
        put :update, {id: proposal.to_param, proposal: valid_attributes}
        expect(assigns(:proposal)).to eq(proposal)
      end

      it "redirects to the proposal" do
        proposal = FactoryGirl.create(:proposal)
        put :update, {id: proposal.to_param, proposal: valid_attributes}
        expect(response).to redirect_to(proposal)
      end
      it "can change the committee" do
        proposal = FactoryGirl.create(:proposal)
        new_c = FactoryGirl.create(:committee)
        put :update, {id: proposal.to_param, proposal: {title: "New Title", committee_id: new_c}}
        expect(response).to redirect_to(proposal)
        proposal = Proposal.find(proposal.id)
        expect(proposal.committee).to eq(new_c)
        expect(proposal.title).to eq("New Title")
      end
    end

    describe "with invalid params" do
      it "assigns the proposal as @proposal" do
        proposal = FactoryGirl.create(:proposal)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Proposal).to receive(:save).and_return(false)
        put :update, {id: proposal.to_param, proposal: {title: 'the prop'}}
        expect(assigns(:proposal)).to eq(proposal)
      end

      it "re-renders the 'edit' template" do
        proposal = FactoryGirl.create(:proposal)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Proposal).to receive(:save).and_return(false)
        put :update, {id: proposal.to_param, proposal: {title: 'the prop'}}
        expect(response).to render_template("edit")
      end
    end
    describe "as a committee-admin for the same committee" do
      before(:each) do
        @proposal = FactoryGirl.create(:proposal, status: "Review")
        sign_out @admin_user
        cm = FactoryGirl.create(:committee_member, committee: @proposal.committee, admin: true)
        @cm_admin_user = cm.user
        sign_in @cm_admin_user
      end
      it "should be able to update" do
        put :update, {id: @proposal.to_param, proposal: valid_attributes}
        expect(response).to redirect_to(@proposal)
      end
    end
  end

  describe "DELETE destroy" do
    let(:committee) { FactoryGirl.create(:committee) }
    it "destroys the requested proposal" do
      proposal = FactoryGirl.create(:proposal, committee: committee)
      expect {
        delete :destroy, {id: proposal.to_param}
      }.to change(Proposal, :count).by(-1)
    end

    it "redirects to the proposals list" do
      proposal = FactoryGirl.create(:proposal, committee: committee)
      delete :destroy, {id: proposal.to_param}
      expect(response).to redirect_to(committee_path(committee))
    end
  end
end
