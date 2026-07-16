require 'spec_helper'

describe Rulebook, type: :model do
  it "should allow 2 rulebooks to exist" do
    FactoryBot.create(:rulebook)
    ac = described_class.new
    ac.subdomain = "new2"
    expect(ac).to be_valid
  end

  it "should be able to have a really long front_page" do
    ac = described_class.new
    ac.front_page = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
    expect(ac.valid?).to eq(true)
    expect(ac.save).to eq(true)
  end
end

# == Schema Information
#
# Table name: public.rulebooks
#
#  id                 :integer          not null, primary key
#  rulebook_name      :string
#  front_page         :text
#  faq                :text
#  created_at         :datetime
#  updated_at         :datetime
#  copyright          :string
#  subdomain          :string
#  admin_upgrade_code :string
#  proposals_allowed  :boolean          default(TRUE), not null
#  voting_days        :integer          default(5), not null
#  review_days        :integer          default(5), not null
#
# Indexes
#
#  index_rulebooks_on_subdomain  (subdomain) UNIQUE
#
