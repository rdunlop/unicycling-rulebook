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

  describe "admin_upgrade_code secrecy" do
    let(:rulebook) { FactoryBot.build(:rulebook, subdomain: "secret", admin_upgrade_code: "SUPERSECRET") }

    it "is excluded from as_json" do
      expect(rulebook.as_json).not_to have_key("admin_upgrade_code")
      expect(rulebook.as_json).to have_key("subdomain")
    end

    it "is excluded from to_json even when other exclusions are given" do
      expect(rulebook.to_json(except: :faq)).not_to include("SUPERSECRET")
    end

    it "is excluded even when explicitly requested with only:" do
      expect(rulebook.to_json(only: %i[subdomain admin_upgrade_code])).not_to include("SUPERSECRET")
    end

    it "is excluded when serializing a collection" do
      expect([rulebook].to_json).not_to include("SUPERSECRET")
    end

    it "is filtered from inspect" do
      expect(rulebook.inspect).not_to include("SUPERSECRET")
    end

    it "is filtered from logged parameters" do
      filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
      filtered = filter.filter("access_code" => "SUPERSECRET", "rulebook" => { "admin_upgrade_code" => "SUPERSECRET" })
      expect(filtered.to_s).not_to include("SUPERSECRET")
    end
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
