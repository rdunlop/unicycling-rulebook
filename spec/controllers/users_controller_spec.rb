require 'spec_helper'

describe UsersController, type: :controller do
  let(:committee) { FactoryBot.create(:committee) }
  before(:each) do
    @user = FactoryBot.create(:user)
    @admin_user = FactoryBot.create(:admin_user)
    sign_in @admin_user
    @cm = FactoryBot.create(:committee_member, committee: committee, user: @admin_user)
    @cm2 = FactoryBot.create(:committee_member, committee: committee, user: @user)
  end

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      name: "My Name",
      location: "Chicago"
    }
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, params: {id: @user.to_param}
      expect(assigns(:user)).to eq(@user)
    end

    describe "as a non-admin" do
      before(:each) do
        sign_out @admin_user
        sign_in @user
      end
      it "should not be able to get" do
        get :edit, params: {id: @user.to_param}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "can update the fields" do
        attrs = {   name: "some",
                    location: "San Francisco" }

        put :update, params: {id: @user.to_param, user: attrs}

        expect(response).to redirect_to(membership_committees_path)
        @user.reload
        expect(@user.name).to eq("some")
        expect(@user.location).to eq("San Francisco")
      end
    end
  end

  describe "DELETE destroy" do
    it "can delete the user who has NO commitee_membership" do
      empty_user = FactoryBot.create(:user)
      expect do
        delete :destroy, params: {id: empty_user.to_param}
      end.to change(User, :count).by(-1)
    end

    it "cannot delete the user who has commitee_membership" do
      expect do
        delete :destroy, params: {id: @user.to_param}
      end.not_to change(User, :count)
    end
  end
end
