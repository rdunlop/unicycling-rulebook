require 'spec_helper'

describe ConfigurationsController, :type => :controller do
  before (:each) do
    @admin_user = FactoryGirl.create(:admin_user)
    sign_in @admin_user
  end

  # This should return the minimal set of attributes required to create a valid
  # Rulebook. As you add validations to Rulebook, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { rulebook_name: "My Rulebook",
      front_page: "Something Interesting",
      faq: "FAQ lives here",
      copyright: "Teh new Copyright",
      subdomain: "the_rulebook",
      proposals_allowed: true
    }
  end

  describe "GET show" do
    it "assigns the requested rulebook as @rulebook" do
      rulebook = Rulebook.create! valid_attributes
      get :show, {:id => rulebook.to_param}
      expect(assigns(:rulebook)).to eq(rulebook)
    end
  end

  describe "GET edit" do
    it "assigns the requested rulebook as @rulebook" do
      rulebook = Rulebook.create! valid_attributes
      get :edit, {:id => rulebook.to_param}
      expect(assigns(:rulebook)).to eq(rulebook)
    end
  end


  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested rulebook" do
        rulebook = Rulebook.create! valid_attributes
        # Assuming there are no other rulebooks in the database, this
        # specifies that the Rulebook created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Rulebook).to receive(:update_attributes).with({})
        put :update, {:id => rulebook.to_param, :rulebook => {'these' => 'params'}}
      end

      it "assigns the requested rulebook as @rulebook" do
        rulebook = Rulebook.create! valid_attributes
        put :update, {:id => rulebook.to_param, :rulebook => valid_attributes}
        expect(assigns(:rulebook)).to eq(rulebook)
      end

      it "redirects to the rulebook" do
        rulebook = Rulebook.create! valid_attributes
        put :update, {:id => rulebook.to_param, :rulebook => valid_attributes}
        expect(response).to redirect_to(configuration_path(rulebook))
      end
    end

    describe "with invalid params" do
      it "assigns the rulebook as @rulebook" do
        rulebook = Rulebook.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Rulebook).to receive(:save).and_return(false)
        put :update, {:id => rulebook.to_param, :rulebook => {rulebook_name: 'the book'}}
        expect(assigns(:rulebook)).to eq(rulebook)
      end

      it "re-renders the 'edit' template" do
        rulebook = Rulebook.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Rulebook).to receive(:save).and_return(false)
        put :update, {:id => rulebook.to_param, :rulebook => {rulebook_name: 'the book'}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @rulebook = Rulebook.create! valid_attributes
      Apartment::Tenant.create(@rulebook.subdomain)
    end
    it "destroys the requested rulebook" do
      expect {
        delete :destroy, {:id => @rulebook.to_param}
      }.to change(Rulebook, :count).by(-1)
    end

    it "redirects to the rulebooks list" do
      delete :destroy, {:id => @rulebook.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

end
