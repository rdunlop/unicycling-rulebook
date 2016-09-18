require 'spec_helper'
RSpec.describe AdminUpgradesController, type: :controller do
  describe "GET new" do
    it 'renders' do
      get :new
    end
  end
end
