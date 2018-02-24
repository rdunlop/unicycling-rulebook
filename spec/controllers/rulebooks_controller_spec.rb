# == Schema Information
#
# Table name: public.rulebooks
#
#  id                 :integer          not null, primary key
#  rulebook_name      :string(255)
#  front_page         :text
#  faq                :text
#  created_at         :datetime
#  updated_at         :datetime
#  copyright          :string(255)
#  subdomain          :string(255)
#  admin_upgrade_code :string(255)
#  proposals_allowed  :boolean          default(TRUE), not null
#

require 'spec_helper'

describe RulebooksController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Rulebook. As you add validations to Rulebook, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { rulebook_name: "My Rulebook",
      front_page: "Something Interesting",
      faq: "FAQ lives here",
      copyright: "Teh new Copyright",
      subdomain: "the_rulebook",
      proposals_allowed: "true"}
  end

  describe "GET index" do
    it "assigns all rulebooks as @rulebooks" do
      rulebook = Rulebook.create! valid_attributes
      get :index
      expect(assigns(:rulebooks)).to include(rulebook)
    end
  end

  describe "GET show" do
    it "assigns the requested rulebook as @rulebook" do
      rulebook = Rulebook.create! valid_attributes
      get :show, params: {id: rulebook.to_param}
      expect(assigns(:rulebook)).to eq(rulebook)
    end
  end

  describe "GET new" do
    it "assigns a new rulebook as @rulebook" do
      get :new
      expect(assigns(:rulebook)).to be_a_new(Rulebook)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Rulebook" do
        expect {
          post :create, params: {rulebook: valid_attributes, access_code: "ACCESS_CODE"}
        }.to change(Rulebook, :count).by(1)
      end

      it "assigns a newly created rulebook as @rulebook" do
        post :create, params: {rulebook: valid_attributes, access_code: "ACCESS_CODE"}
        expect(assigns(:rulebook)).to be_a(Rulebook)
        expect(assigns(:rulebook)).to be_persisted
      end

      it "redirects to the created rulebook" do
        post :create, params: {rulebook: valid_attributes, access_code: "ACCESS_CODE"}
        expect(response).to redirect_to(Rulebook.last)
      end

      it "fails with an invalid access code" do
        expect {
          post :create, params: {rulebook: valid_attributes, access_code: "NO CODE"}
        }.not_to change(Rulebook, :count)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved rulebook as @rulebook" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Rulebook).to receive(:save).and_return(false)
        post :create, params: {rulebook: {rulebook_name: 'the book'}}
        expect(assigns(:rulebook)).to be_a_new(Rulebook)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Rulebook).to receive(:save).and_return(false)
        post :create, params: {rulebook: {rulebook_name: 'the book'}, access_code: "ACCESS_CODE"}
        expect(response).to render_template("new")
      end
    end
  end
end
