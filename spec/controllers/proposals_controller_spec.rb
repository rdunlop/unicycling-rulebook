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

describe ProposalsController do
  before (:each) do
    @committee = FactoryGirl.create(:committee)

    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
    sign_in @admin_user
  end

  # This should return the minimal set of attributes required to create a valid
  # Proposal. As you add validations to Proposal, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        title: "My Title",
        committee_id: @committee.id}
  end
  
  describe "GET index" do
    it "assigns all proposals as @proposals" do
      proposal = FactoryGirl.create(:proposal)
      get :index, {}
      assigns(:proposals).should eq([proposal])
    end
  end

  describe "GET show" do
    it "assigns the requested proposal as @proposal" do
      proposal = FactoryGirl.create(:proposal)
      get :show, {:id => proposal.to_param}
      assigns(:proposal).should eq(proposal)
    end

    it "should have a blank comment object" do
      proposal = FactoryGirl.create(:proposal)
      get :show, {:id => proposal.to_param}
      assigns(:comment).should be_a_new(Comment)
    end
    it "should have a blank vote object" do
      proposal = FactoryGirl.create(:proposal)
      get :show, {:id => proposal.to_param}
      assigns(:vote).should be_a_new(Vote)
    end
    it "should have the existing vote object for this user" do
      proposal = FactoryGirl.create(:proposal)
      vote = FactoryGirl.create(:vote, :proposal => proposal, :user => @admin_user)
      get :show, {:id => proposal.to_param}
      assigns(:vote).should == vote
    end
  end

  describe "GET new" do
    it "assigns a new proposal as @proposal" do
      get :new, {}
      assigns(:proposal).should be_a_new(Proposal)
    end
    it "should set the owner to be the current-logged-in user" do
      get :new, {}
      assigns(:proposal).owner.should == @admin_user
    end
    it "should also have a @revision" do
      get :new, {}
      assigns(:revision).should be_a_new(Revision)
    end
  end

  describe "GET edit" do
    it "assigns the requested proposal as @proposal" do
      proposal = FactoryGirl.create(:proposal)
      get :edit, {:id => proposal.to_param}
      assigns(:proposal).should eq(proposal)
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
          post :create, {:proposal => valid_attributes, :revision => @valid_revision_attributes}
        }.to change(Proposal, :count).by(1)
      end

      it "assigns a newly created proposal as @proposal" do
        post :create, {:proposal => valid_attributes, :revision => @valid_revision_attributes}
        assigns(:proposal).should be_a(Proposal)
        assigns(:proposal).should be_persisted
        assigns(:revision).should be_a(Revision)
        assigns(:revision).should be_persisted
      end

      it "redirects to the created proposal" do
        post :create, {:proposal => valid_attributes, :revision => @valid_revision_attributes}
        response.should redirect_to(Proposal.last)
      end
      it "should increase revision count" do
        expect {
          post :create, {:proposal => valid_attributes, :revision => @valid_revision_attributes}
        }.to change(Revision, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved proposal as @proposal" do
        # Trigger the behavior that occurs when invalid params are submitted
        Proposal.any_instance.stub(:save).and_return(false)
        post :create, {:proposal => {}}
        assigns(:proposal).should be_a_new(Proposal)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Proposal.any_instance.stub(:save).and_return(false)
        post :create, {:proposal => {}}
        response.should render_template("new")
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
        Proposal.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => proposal.to_param, :proposal => {'these' => 'params'}}
      end

      it "assigns the requested proposal as @proposal" do
        proposal = FactoryGirl.create(:proposal)
        put :update, {:id => proposal.to_param, :proposal => valid_attributes}
        assigns(:proposal).should eq(proposal)
      end

      it "redirects to the proposal" do
        proposal = FactoryGirl.create(:proposal)
        put :update, {:id => proposal.to_param, :proposal => valid_attributes}
        response.should redirect_to(proposal)
      end
    end

    describe "with invalid params" do
      it "assigns the proposal as @proposal" do
        proposal = FactoryGirl.create(:proposal)
        # Trigger the behavior that occurs when invalid params are submitted
        Proposal.any_instance.stub(:save).and_return(false)
        put :update, {:id => proposal.to_param, :proposal => {}}
        assigns(:proposal).should eq(proposal)
      end

      it "re-renders the 'edit' template" do
        proposal = FactoryGirl.create(:proposal)
        # Trigger the behavior that occurs when invalid params are submitted
        Proposal.any_instance.stub(:save).and_return(false)
        put :update, {:id => proposal.to_param, :proposal => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested proposal" do
      proposal = FactoryGirl.create(:proposal)
      expect {
        delete :destroy, {:id => proposal.to_param}
      }.to change(Proposal, :count).by(-1)
    end

    it "redirects to the proposals list" do
      proposal = FactoryGirl.create(:proposal)
      delete :destroy, {:id => proposal.to_param}
      response.should redirect_to(proposals_url)
    end
  end

  describe "PUT set_voting" do
    it "changes the status to voting" do
        proposal = FactoryGirl.create(:proposal, :status => "Pre-Voting")

        put :set_voting, {:id => proposal.to_param}

        response.should redirect_to(proposal_path(proposal))
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Voting"
        # the following subtraction yields fractions-of-a-day
        ((proposal.vote_start_date - DateTime.now()) * 1.days).should < 2
    end

    it "should not be allowed to change unless the status is Pre-Voting" do
        proposal = FactoryGirl.create(:proposal, :status => "Tabled")

        put :set_voting, {:id => proposal.to_param}

        response.should render_template("edit")
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Tabled"
    end
  end

  describe "PUT set_review" do
    it "changes the status to Review" do
        proposal = FactoryGirl.create(:proposal, :status => "Submitted")

        put :set_review, {:id => proposal.to_param}

        response.should redirect_to(proposal_path(proposal))
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Review"
        # the following subtraction yields fractions-of-a-day
        ((proposal.review_start_date - DateTime.now()) * 1.days).should < 2
    end

    it "changes the status to Review from Tabled status" do
        proposal = FactoryGirl.create(:proposal, :status => "Tabled")

        put :set_review, {:id => proposal.to_param}

        response.should redirect_to(proposal_path(proposal))
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Review"
        # the following subtraction yields fractions-of-a-day
        ((proposal.review_start_date - DateTime.now()) * 1.days).should < 2
    end

    it "should not be allowed to change unless the status is Submitted" do
        proposal = FactoryGirl.create(:proposal, :status => "Pre-Voting")

        put :set_review, {:id => proposal.to_param}

        response.should render_template("edit")
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Pre-Voting"
    end
  end

  describe "PUT set_pre_voting" do
    before(:each) do
        sign_out @admin_user
        sign_in @admin_user
    end

    it "changes the status to Pre-Voting" do
        proposal = FactoryGirl.create(:proposal, :status => "Voting")

        put :set_pre_voting, {:id => proposal.to_param}

        response.should redirect_to(proposal_path(proposal))
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Pre-Voting"
    end

    it "changes the status to Pre-Voting should remove any votes" do
        proposal = FactoryGirl.create(:proposal, :status => "Voting")
        vote = FactoryGirl.create(:vote, :proposal => proposal)

        proposal.votes.count.should == 1

        put :set_pre_voting, {:id => proposal.to_param}

        response.should redirect_to(proposal_path(proposal))
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Pre-Voting"
        proposal.votes.count.should == 0
    end

    it "should not be allowed to change unless the status is Voting" do
        proposal = FactoryGirl.create(:proposal, :status => "Tabled")

        put :set_pre_voting, {:id => proposal.to_param}

        response.should render_template("edit")
        proposal = Proposal.find(proposal.id)
        proposal.status.should == "Tabled"
    end
  end
end
