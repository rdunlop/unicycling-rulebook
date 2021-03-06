# == Schema Information
#
# Table name: revisions
#
#  id                 :integer          not null, primary key
#  proposal_id        :integer
#  body               :text
#  background         :text
#  references         :text
#  change_description :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  num                :integer
#  rule_text          :text
#

require 'spec_helper'
describe RevisionsController, type: :controller do
  before(:each) do
    @proposal = FactoryBot.create(:proposal, :with_admin)
    @revision = FactoryBot.create(:revision, proposal: @proposal, user_id: @proposal.owner.id)
    @proposal.reload
    @discussion = FactoryBot.create(:discussion, proposal: @proposal, owner_id: @proposal.owner.id, committee: @proposal.committee)

    @admin = FactoryBot.create(:admin_user)
    sign_in @admin
  end

  # This should return the minimal set of attributes required to create a valid
  # Revision. As you add validations to Revision, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { body: "blah",
      rule_text: 'Something',
      change_description: "blaa"}
  end

  describe "GET show" do
    it "assigns the requested revision as @revision" do
      revision = FactoryBot.create(:revision, proposal: @proposal)
      get :show, params: {id: revision.to_param, proposal_id: @proposal.id}
      expect(assigns(:revision)).to eq(revision)
    end
    it "can see the revision of a 'Submitted' proposal as a normal user" do
      user = @proposal.owner
      FactoryBot.create(:committee_member, committee: @proposal.committee, user: user)
      sign_out @admin
      sign_in user
      get :show, params: {id: @revision.to_param, proposal_id: @proposal.id}
      expect(assigns(:revision)).to eq(@revision)
      expect(response).to be_successful
      expect(response).to render_template("show")
    end
    describe "as an editor" do
      before(:each) do
        @editor = FactoryBot.create(:user)
        FactoryBot.create(:committee_member, committee: @proposal.committee, user: @proposal.owner)
        FactoryBot.create(:committee_member, committee: @proposal.committee, user: @editor, editor: true)
        sign_out @admin
      end
      it "can view revisions" do
        sign_in @editor
        @proposal.status = 'Review'
        @proposal.save
        get :show, params: {id: @revision.to_param, proposal_id: @proposal.id}
        expect(assigns(:revision)).to eq(@revision)
      end
    end
  end

  describe "GET new" do
    it "assigns a new revision as @revision" do
      get :new, params: {proposal_id: @proposal.id}
      expect(assigns(:revision)).to be_a_new(Revision)
    end
    it "should contain information from previous revision" do
      get :new, params: {proposal_id: @proposal.id}
      expect(assigns(:revision).background).to eq(@proposal.latest_revision.background)
      expect(assigns(:revision).body).to eq(@proposal.latest_revision.body)
      expect(assigns(:revision).rule_text).to eq(@proposal.latest_revision.rule_text)
      expect(assigns(:revision).references).to eq(@proposal.latest_revision.references)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Revision" do
        expect {
          post :create, params: {revision: valid_attributes, proposal_id: @proposal.id}
        }.to change(Revision, :count).by(1)
      end
      describe "as a normal user" do
        before(:each) do
          sign_out @admin
          @user = FactoryBot.create(:user)
          @prop = FactoryBot.create(:proposal, owner: @user, status: 'Review')
          cm = FactoryBot.create(:committee_member, user: @user, committee: @prop.committee)
          sign_in @user
        end
        it "can create a revision to my own proposal" do
          post :create, params: {revision: valid_attributes, proposal_id: @prop.id}
          expect(assigns(:revision)).to be_persisted
          expect(response).to redirect_to([@prop, Revision.last])
        end
      end
      describe "as an editor" do
        before(:each) do
          sign_out @admin
          @user = FactoryBot.create(:user)
          @editor = FactoryBot.create(:user)
          @prop = FactoryBot.create(:proposal, owner: @user, status: 'Review')
          cm = FactoryBot.create(:committee_member, user: @user, committee: @prop.committee)
          cm = FactoryBot.create(:committee_member, user: @editor, editor: true, committee: @prop.committee)
          sign_in @editor
        end
        it "can create a revision to another proposal" do
          post :create, params: {revision: valid_attributes, proposal_id: @prop.id}
          expect(assigns(:revision)).to be_persisted
          expect(response).to redirect_to([@prop, Revision.last])
        end
      end

      it "assigns a newly created revision as @revision" do
        post :create, params: {revision: valid_attributes, proposal_id: @proposal.id}
        expect(assigns(:revision)).to be_a(Revision)
        expect(assigns(:revision)).to be_persisted
      end

      it "redirects to the created revision" do
        post :create, params: {revision: valid_attributes, proposal_id: @proposal.id}
        expect(response).to redirect_to([@proposal, Revision.last])
        expect(Revision.last.user).to eq(@admin)
        expect(Revision.last.proposal).to eq(@proposal)
      end
      it "sends an e-mail when a new revision is created" do
        ActionMailer::Base.deliveries.clear
        post :create, params: {revision: valid_attributes, proposal_id: @proposal.id}
        num_deliveries = ActionMailer::Base.deliveries.size
        expect(num_deliveries).to eq(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved revision as @revision" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Revision).to receive(:save).and_return(false)
        post :create, params: {revision: {body: 'fake'}, proposal_id: @proposal.id}
        expect(assigns(:revision)).to be_a_new(Revision)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Revision).to receive(:save).and_return(false)
        post :create, params: {revision: {body: 'fake'}, proposal_id: @proposal.id}
        expect(response).to render_template("new")
      end
    end
    describe "with a Pre-Voting status proposal" do
      before(:each) do
        @proposal.status = 'Pre-Voting'
        @proposal.save!
      end
      it "should set the status to review" do
        post :create, params: {revision: valid_attributes, proposal_id: @proposal.id}
        expect(assigns(:proposal).status).to eq('Review')
      end
      it "should set the review_start_date and review_end_date" do
        post :create, params: {revision: valid_attributes, proposal_id: @proposal.id}
        expect((assigns(:proposal).review_start_date - DateTime.now()) * 1.day).to be < 1
        expect((assigns(:proposal).review_end_date - DateTime.now()) * 1.day).to be > 2
      end
    end
  end
end
