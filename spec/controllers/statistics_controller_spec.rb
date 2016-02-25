require 'spec_helper'

describe StatisticsController, type: :controller do
  let(:admin_user) { FactoryGirl.create(:admin_user) }

  before(:each) do
    sign_in admin_user
  end

  describe "GET index" do
    before do
      FactoryGirl.create(:comment) # with a user
      FactoryGirl.create(:vote) # with another user
    end

    it "displays" do
      get :index
    end
  end
end
