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

describe RevisionsController do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    @revision = FactoryGirl.create(:revision, :proposal => @proposal)

    @admin = FactoryGirl.create(:admin_user)
    sign_in @admin
  end

  # This should return the minimal set of attributes required to create a valid
  # Revision. As you add validations to Revision, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { body: "blah",
      change_description: "blaa"}
  end
  
  describe "GET show" do
    it "assigns the requested revision as @revision" do
      revision = Revision.create! valid_attributes
      get :show, {:id => revision.to_param, :proposal_id => @proposal.id}
      assigns(:revision).should eq(revision)
    end
  end

  describe "GET new" do
    it "assigns a new revision as @revision" do
      get :new, {:proposal_id => @proposal.id}
      assigns(:revision).should be_a_new(Revision)
    end
    it "should contain information from previous revision" do
      get :new, {:proposal_id => @proposal.id}
      assigns(:revision).background.should == @proposal.latest_revision.background
      assigns(:revision).body.should == @proposal.latest_revision.body
      assigns(:revision).references.should == @proposal.latest_revision.references
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Revision" do
        expect {
          post :create, {:revision => valid_attributes, :proposal_id => @proposal.id}
        }.to change(Revision, :count).by(1)
      end

      it "assigns a newly created revision as @revision" do
        post :create, {:revision => valid_attributes, :proposal_id => @proposal.id}
        assigns(:revision).should be_a(Revision)
        assigns(:revision).should be_persisted
      end

      it "redirects to the created revision" do
        post :create, {:revision => valid_attributes, :proposal_id => @proposal.id}
        response.should redirect_to([@proposal, Revision.last])
        Revision.last.user.should == @admin
        Revision.last.proposal.should == @proposal
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved revision as @revision" do
        # Trigger the behavior that occurs when invalid params are submitted
        Revision.any_instance.stub(:save).and_return(false)
        post :create, {:revision => {}, :proposal_id => @proposal.id}
        assigns(:revision).should be_a_new(Revision)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Revision.any_instance.stub(:save).and_return(false)
        post :create, {:revision => {}, :proposal_id => @proposal.id}
        response.should render_template("new")
      end
    end
  end
end
