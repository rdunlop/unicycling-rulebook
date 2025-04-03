require 'spec_helper'

describe ConfigurationsController, type: :controller do
  let(:rulebook) { Rulebook.create! valid_attributes }

  before (:each) do
    Apartment::Tenant.create(rulebook.subdomain)
    Apartment::Tenant.switch!(rulebook.subdomain)
    @admin_user = FactoryBot.create(:admin_user)
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
      proposals_allowed: true,
      voting_days: 6,
      review_days: 7}
  end

  describe "GET show" do
    it "assigns the requested rulebook as @rulebook" do
      get :show, params: {id: rulebook.to_param}
      expect(assigns(:rulebook)).to eq(rulebook)
    end
  end

  describe "GET edit" do
    it "assigns the requested rulebook as @rulebook" do
      get :edit, params: {id: rulebook.to_param}
      expect(assigns(:rulebook)).to eq(rulebook)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested rulebook as @rulebook" do
        put :update, params: {id: rulebook.to_param, rulebook: valid_attributes}
        expect(assigns(:rulebook)).to eq(rulebook)
      end

      it "redirects to the rulebook" do
        put :update, params: {id: rulebook.to_param, rulebook: valid_attributes}
        expect(response).to redirect_to(configuration_path(rulebook))
      end
    end

    describe "with invalid params" do
      it "assigns the rulebook as @rulebook" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Rulebook).to receive(:save).and_return(false)
        put :update, params: {id: rulebook.to_param, rulebook: {rulebook_name: 'the book'}}
        expect(assigns(:rulebook)).to eq(rulebook)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Rulebook).to receive(:save).and_return(false)
        put :update, params: {id: rulebook.to_param, rulebook: {rulebook_name: 'the book'}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested rulebook" do
      expect {
        delete :destroy, params: {id: rulebook.to_param}
      }.to change(Rulebook, :count).by(-1)
    end

    it "redirects to the rulebooks list" do
      delete :destroy, params: {id: rulebook.to_param}
      expect(response).to redirect_to(welcome_index_all_path)
    end
  end
end
