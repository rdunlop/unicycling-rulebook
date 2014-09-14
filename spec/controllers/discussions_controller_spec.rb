require 'spec_helper'

describe DiscussionsController do
  before(:each) do
    @admin = FactoryGirl.create(:admin_user)
    sign_in @admin
  end

  # This should return the minimal set of attributes required to create a valid
  # Revision. As you add validations to Revision, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { body: "blah",
      title: 'Something' }
  end

  let(:committee) { FactoryGirl.create(:committee) }

  describe "GET show" do
    it "assigns the requested revision as @revision" do
      discussion = FactoryGirl.create(:discussion)

      get :show, { :id => discussion.to_param }

      assigns(:discussion).should eq(discussion)
    end
  end

  describe "GET new" do
    it "assigns a new discussion as @discussion" do
      get :new, { :committee_id => committee.id }
      assigns(:discussion).should be_a_new(Discussion)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      describe "as a committee member" do
        before do
          FactoryGirl.create(:committee_member, committee: committee, user: @admin)
        end
        it "creates a new Discussion" do
          expect {
            post :create, { :discussion => valid_attributes, :committee_id => committee.id}
          }.to change(Discussion, :count).by(1)
        end
      end
      describe "as a non-comimttee member" do
        it "does not create a new Discussion" do
          expect {
            post :create, { :discussion => valid_attributes, :committee_id => committee.id}
          }.to change(Discussion, :count).by(0)
        end
      end
    end
  end
end
