# == Schema Information
#
# Table name: committee_members
#
#  id           :integer          not null, primary key
#  committee_id :integer
#  user_id      :integer
#  voting       :boolean          default(TRUE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  admin        :boolean          default(FALSE), not null
#  editor       :boolean          default(FALSE), not null
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

describe CommitteeMembersController, type: :controller do
  before (:each) do
    @committee = FactoryGirl.create(:committee)
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
    sign_in @user
  end

  # This should return the minimal set of attributes required to create a valid
  # Event. As you add validations to Event, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { user_id: [@user.id],
      admin: false,
      editor: false,
      voting: true}
  end

  describe "GET index" do
    it "fails when not logged in" do
      sign_out @user
      get :index, params: {committee_id: @committee.id}
      expect(response).to redirect_to(new_user_session_path)
    end

    describe "as admin user" do
      before(:each) do
        sign_out @user
        sign_in @admin_user
      end
      it "assigns all committee_members as @committee_members" do
        cm = FactoryGirl.create(:committee_member, committee: @committee)
        get :index, params: {committee_id: @committee.id}
        expect(assigns(:committee_members)).to eq([cm])
      end
      it "should only show members for this committee" do
        cm = FactoryGirl.create(:committee_member, committee: @committee)
        other_cm = FactoryGirl.create(:committee_member)
        get :index, params: {committee_id: @committee.id}
        expect(assigns(:committee_members)).to eq([cm])
      end
    end
    describe "as committee_admin user" do
      before(:each) do
        @committee_admin = FactoryGirl.create(:user)
        @cm = FactoryGirl.create(:committee_member, admin: true, user: @committee_admin)
        sign_out @user
        sign_in @committee_admin
      end
      it "should allow access" do
        get :index, params: {committee_id: @cm.committee.id}
        expect(response).to be_success
        expect(assigns(:committee_members)).to eq([@cm])
      end
    end
  end

  describe "GET new" do
    describe "as a super-admin" do
      before(:each) do
        sign_out @user
        sign_in @admin_user
      end
      it "can access the :new page" do
        get :new, params: {committee_id: @committee.id}
        expect(response).to be_success
      end

      it "assigns a new committee_member as @committee_member" do
        get :new, params: {committee_id: @committee.id}
        expect(assigns(:committee_member)).to be_a_new(CommitteeMember)
      end
      it "assigns all users to @users" do
        get :new, params: {committee_id: @committee.id}
        expect(assigns(:users)).to match_array([@user, @admin_user])
      end
      it "only assigns new members to @users" do
        FactoryGirl.create(:committee_member, committee: @committee, user: @admin_user)
        get :new, params: {committee_id: @committee.id}
        expect(assigns(:users)).to match_array([@user])
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested committee as @committee" do
      sign_out @user
      sign_in @admin_user
      committee_member = FactoryGirl.create(:committee_member, committee: @committee)
      get :edit, params: {id: committee_member.to_param, committee_id: @committee.id}
      expect(assigns(:committee_member)).to eq(committee_member)
    end
    describe "as committee_admin user" do
      before(:each) do
        @committee_admin = FactoryGirl.create(:user)
        @cm = FactoryGirl.create(:committee_member, admin: true, user: @committee_admin)
        sign_out @user
        sign_in @committee_admin
      end
      it "can edit a user" do
        get :edit, params: {id: @cm.to_param, committee_id: @cm.committee.id}
        expect(response).to be_success
        expect(assigns(:committee_member)).to eq(@cm)
      end
    end
  end

  describe "POST create" do
    before (:each) do
      sign_out @user
      sign_in @admin_user
    end
    describe "with valid params" do
      it "creates a new Committee Member" do
        expect {
          post :create, params: {committee_member: valid_attributes, committee_id: @committee.id}
        }.to change(CommitteeMember, :count).by(1)
      end
      it "creates multiple committee Members" do
        @user2 = FactoryGirl.create(:user)
        expect {
          post :create, params: {committee_member: {user_id: [@user.id, @user2.id], admin: false, editor: false, voting: false}, committee_id: @committee.id}
        }.to change(CommitteeMember, :count).by(2)
      end

      it "assigns a newly created committee_member as @committee_member" do
        post :create, params: {committee_member: valid_attributes, committee_id: @committee.id}
        expect(assigns(:committee_member)).to be_a(CommitteeMember)
        expect(assigns(:committee_member)).to be_persisted
        expect(assigns(:committee_member).admin).to eq(false)
      end
      it "sets the admin status correctly" do
        post :create, params: {committee_member: {user_id: [@user.id], admin: true, editor: false, voting: false }, committee_id: @committee.id}
        expect(assigns(:committee_member).admin).to eq(true)
      end
      it "sets the editor status correctly" do
        post :create, params: {committee_member: {user_id: [@user.id], admin: false, editor: true, voting: false }, committee_id: @committee.id}
        expect(assigns(:committee_member).editor).to eq(true)
      end

      it "redirects to the created committee_member" do
        post :create, params: {committee_member: valid_attributes, committee_id: @committee.id}
        expect(response).to redirect_to(committee_committee_members_path(@committee))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved committee_member as @committee_member" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CommitteeMember).to receive(:save).and_return(false)
        post :create, params: {committee_member: {admin: true}, committee_id: @committee.id}
        expect(assigns(:committee_member)).to be_a_new(CommitteeMember)
      end
      it "loads the list of users" do
        allow_any_instance_of(CommitteeMember).to receive(:save).and_return(false)
        post :create, params: {committee_member: {admin: true}, committee_id: @committee.id}
        expect(assigns(:users)).to match_array([@user, @admin_user])
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CommitteeMember).to receive(:save).and_return(false)
        post :create, params: {committee_member: {admin: true}, committee_id: @committee.id}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    before (:each) do
      sign_out @user
      sign_in @admin_user
    end
    describe "with valid params" do
      it "assigns the requested committee_member as @committee" do
        committee_member = FactoryGirl.create(:committee_member, committee: @committee)
        put :update, params: {id: committee_member.to_param, committee_member: {user_id: @user.id, admin: false, voting: true }, committee_id: @committee.id}
        expect(assigns(:committee_member)).to eq(committee_member)
      end

      it "redirects to the committee" do
        committee_member = FactoryGirl.create(:committee_member, committee: @committee)
        put :update, params: {id: committee_member.to_param, committee_member: {user_id: @user.id, admin: false, voting: true}, committee_id: @committee.id}
        expect(response).to redirect_to(committee_committee_members_path(@committee))
      end

      it "sets the editor flag" do
        committee_member = FactoryGirl.create(:committee_member, committee: @committee)
        put :update, params: {id: committee_member.to_param, committee_member: {user_id: @user.id, editor: true, voting: true}, committee_id: @committee.id}
        cm = CommitteeMember.find(committee_member.id)
        expect(cm.editor).to eq(true)
      end
    end

    describe "with invalid params" do
      it "assigns the committee_member as @committee" do
        committee_member = FactoryGirl.create(:committee_member, committee: @committee)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CommitteeMember).to receive(:save).and_return(false)
        put :update, params: {id: committee_member.to_param, committee_member: {admin: true}, committee_id: @committee.id}
        expect(assigns(:committee_member)).to eq(committee_member)
      end

      it "re-renders the 'edit' template" do
        committee_member = FactoryGirl.create(:committee_member, committee: @committee)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CommitteeMember).to receive(:save).and_return(false)
        put :update, params: {id: committee_member.to_param, committee_member: {admin: true}, committee_id: @committee.id}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before (:each) do
      sign_out @user
      sign_in @admin_user
    end
    it "destroys the requested committee" do
      committee_member = FactoryGirl.create(:committee_member, committee: @committee)
      expect {
        delete :destroy, params: {id: committee_member.to_param, committee_id: @committee.id}
      }.to change(CommitteeMember, :count).by(-1)
    end

    it "redirects to the committee_member list" do
      committee_member = FactoryGirl.create(:committee_member, committee: @committee)
      delete :destroy, params: {id: committee_member.to_param, committee_id: @committee.id}
      expect(response).to redirect_to(committee_committee_members_path(@committee))
    end
  end
end
