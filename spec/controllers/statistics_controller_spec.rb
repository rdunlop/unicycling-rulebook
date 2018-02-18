require 'spec_helper'

describe StatisticsController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin_user) }

  before(:each) do
    sign_in admin_user
  end

  describe "GET index" do
    before do
      FactoryBot.create(:comment) # with a user
      FactoryBot.create(:vote) # with another user
    end

    it "displays" do
      get :index
    end
  end
end
