require 'spec_helper'

describe ReviewState do
  let(:proposal) { FactoryGirl.create(:proposal, :review) }
  let(:subject) { described_class.new(proposal) }

  it "can transition to Tabled" do
    expect(subject.transition_to("Tabled")).to be_truthy
  end
end
