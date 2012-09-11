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

describe CommitteesController do
  before (:each) do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
    sign_in @user
  end

  # This should return the minimal set of attributes required to create a valid
  # Event. As you add validations to Event, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { name: "MyName"
    }
  end
  
  describe "GET index" do
    it "fails when not logged in" do
      sign_out @user
      get :index
      response.should redirect_to(new_user_session_path)
    end

    it "assigns all committees as @committees" do
      committee = Committee.create! valid_attributes
      get :index, {}
      assigns(:committees).should eq([committee])
    end
  end

  describe "GET new" do
    it "fails when not an Admin" do
      get :new, {}
      response.should redirect_to(root_path)
    end

    it "assigns a new committee as @committee" do
      sign_out @user
      sign_in @admin_user
      get :new, {}
      assigns(:committee).should be_a_new(Committee)
    end
  end

  describe "GET edit" do
    it "fails when not admin user" do
      committee = Committee.create! valid_attributes
      get :edit, {:id => committee.to_param}
      response.should redirect_to(root_path)
    end

    it "assigns the requested committee as @committee" do
      sign_out @user
      sign_in @admin_user
      committee = Committee.create! valid_attributes
      get :edit, {:id => committee.to_param}
      assigns(:committee).should eq(committee)
    end
  end

  describe "POST create" do
    before (:each) do
      sign_out @user
      sign_in @admin_user
    end
    describe "with valid params" do
      it "creates a new Committee" do
        expect {
          post :create, {:committee => valid_attributes}
        }.to change(Committee, :count).by(1)
      end

      it "assigns a newly created committee as @committee" do
        post :create, {:committee => valid_attributes}
        assigns(:committee).should be_a(Committee)
        assigns(:committee).should be_persisted
      end

      it "redirects to the created committee" do
        post :create, {:committee => valid_attributes}
        response.should redirect_to(committees_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved committee as @committee" do
        # Trigger the behavior that occurs when invalid params are submitted
        Committee.any_instance.stub(:save).and_return(false)
        post :create, {:committee => {}}
        assigns(:committee).should be_a_new(Committee)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Committee.any_instance.stub(:save).and_return(false)
        post :create, {:committee => {}}
        response.should render_template("new")
      end
    end
    
    describe "with non-admin user" do
    before (:each) do
      sign_out @admin_user
      sign_in @user
    end
      it "should fail" do
        post :create, {:committee => valid_attributes}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT update" do
    before (:each) do
      sign_out @user
      sign_in @admin_user
    end
    describe "with valid params" do
      it "updates the requested committee" do
        committee = Committee.create! valid_attributes
        # Assuming there are no other events in the database, this
        # specifies that the Committee created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Committee.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => committee.to_param, :committee => {'these' => 'params'}}
      end

      it "assigns the requested committee as @committee" do
        committee = Committee.create! valid_attributes
        put :update, {:id => committee.to_param, :committee => valid_attributes}
        assigns(:committee).should eq(committee)
      end

      it "redirects to the committee" do
        committee = Committee.create! valid_attributes
        put :update, {:id => committee.to_param, :committee => valid_attributes}
        response.should redirect_to(committees_path)
      end
    end

    describe "with invalid params" do
      it "assigns the committee as @committee" do
        committee = Committee.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Committee.any_instance.stub(:save).and_return(false)
        put :update, {:id => committee.to_param, :committee => {}}
        assigns(:committee).should eq(committee)
      end

      it "re-renders the 'edit' template" do
        committee = Committee.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Committee.any_instance.stub(:save).and_return(false)
        put :update, {:id => committee.to_param, :committee => {}}
        response.should render_template("edit")
      end
    end

    describe "with non-admin user" do
    before (:each) do
      sign_out @admin_user
      sign_in @user
    end
      it "should fail" do
        committee = Committee.create! valid_attributes
        put :update, {:id => committee.to_param, :committee => valid_attributes}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE destroy" do
    before (:each) do
      sign_out @user
      sign_in @admin_user
    end
    it "destroys the requested committee" do
      committee = Committee.create! valid_attributes
      expect {
        delete :destroy, {:id => committee.to_param}
      }.to change(Committee, :count).by(-1)
    end

    it "redirects to the committee list" do
      committee = Committee.create! valid_attributes
      delete :destroy, {:id => committee.to_param}
      response.should redirect_to(committees_url)
    end
    describe "with non-admin user" do
      it "fails to delete" do
        sign_out @admin_user
        sign_in @user
        committee = Committee.create! valid_attributes
        delete :destroy, {:id => committee.to_param}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET membership" do
    it "assigns all committees as @committees" do
      committee = FactoryGirl.create(:committee)
      get :membership
      response.should be_success
      assigns(:committees).should == [committee]
    end
    it "should assign all users as @users" do
      get :membership
      response.should be_success
      assigns(:users).should =~ [@user, @admin_user]
    end
  end
end
