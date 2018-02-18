require "spec_helper"

describe StatisticsPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin_user) }

  let(:subject) { described_class }
  let(:committee) { FactoryBot.create :committee }

  permissions :index? do
    it { expect(subject).to permit(admin) }
    it { expect(subject).not_to permit(user) }
  end
end
