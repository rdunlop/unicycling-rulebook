require 'spec_helper'

describe Proposal, type: :model do
  it "should have an associated user" do
    prop = Proposal.new
    prop.committee = FactoryGirl.create(:committee)
    prop.title = "Hello People"
    prop.status = 'Submitted'
    expect(prop.valid?).to eq(false)

    prop.owner = FactoryGirl.create(:user)
    expect(prop.valid?).to eq(true)
  end

  it "must have a title" do
    prop = Proposal.new
    prop.status = 'Submitted'
    prop.owner = FactoryGirl.create(:user)
    prop.committee = FactoryGirl.create(:committee)
    expect(prop.valid?).to eq(false)

    prop.title = "Hi there"
    expect(prop.valid?).to eq(true)
  end

  it "should have an associated committee" do
    prop = Proposal.new
    prop.status = 'Submitted'
    prop.title = "Hello People"
    prop.owner = FactoryGirl.create(:user)
    expect(prop.valid?).to eq(false)

    prop.committee = FactoryGirl.create(:committee)
    expect(prop.valid?).to eq(true)
  end

  it "should return its title as the default string" do
    prop = FactoryGirl.create(:proposal)

    expect(prop.to_s).to eq(prop.title)
  end

  it "should have associated votes" do
    proposal = FactoryGirl.create(:proposal)
    vote = FactoryGirl.create(:vote, proposal: proposal)

    prop = Proposal.find(proposal.id)

    expect(prop.votes.count).to eq(1)
  end
  it "orders the votes by created_at date" do
    proposal = FactoryGirl.create(:proposal)
    vote2 = FactoryGirl.create(:vote, proposal: proposal, created_at: 1.second.ago)
    vote1 = FactoryGirl.create(:vote, proposal: proposal, created_at: 2.seconds.ago)

    prop = Proposal.find(proposal.id)

    expect(prop.votes).to eq([vote1, vote2])
  end

  it "should only allow certain status values" do
    proposal = FactoryGirl.create(:proposal)
    expect(proposal.valid?).to eq(true)

    proposal.status = "Submitted"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Review"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Pre-Voting"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Voting"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Tabled"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Passed"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Failed"
    expect(proposal.valid?).to eq(true)
    proposal.status = "Robin"
    expect(proposal.valid?).to eq(false)
  end

  it "should have a latest_revision_number" do
    revision = FactoryGirl.create(:revision)
    prop = revision.proposal

    expect(prop.latest_revision_number).to eq(revision.num)
  end
  it "should provide all revisions in descending order" do
    prop = FactoryGirl.create(:proposal)
    rev1 = FactoryGirl.create(:revision, proposal: prop)
    rev2 = FactoryGirl.create(:revision, proposal: prop)

    expect(prop.revisions).to eq([rev2, rev1])
  end

  describe "when checking the 'status_string'" do
    it "should print only the status for a Submitted proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Submitted')
      expect(prop.status_string).to eq("Submitted")
    end
    it "should print the review dates for a Review proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Review',
                                           review_start_date: Date.new(2012, 1, 1),
                                           review_end_date: Date.new(2012, 1, 10))
      expect(prop.status_string).to eq("Review from January 01, 2012 to January 10, 2012")
    end

    it "should print the review dates for a Pre-Voting proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Pre-Voting',
                                           review_start_date: Date.new(2012, 1, 1),
                                           review_end_date: Date.new(2012, 1, 10))
      expect(prop.status_string).to eq("Pre-Voting (Reviewed from January 01, 2012 to January 10, 2012)")
    end
    it "should print the voting dates for a Voting proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Voting',
                                           vote_start_date: Date.new(2012, 1, 1),
                                           vote_end_date: Date.new(2012, 1, 10))
      expect(prop.status_string).to eq("Voting from January 01, 2012 to January 10, 2012")
    end
    it "should print the review dates for a Tabled proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Tabled',
                                           review_start_date: Date.new(2012, 1, 1),
                                           review_end_date: Date.new(2012, 1, 10))
      expect(prop.status_string).to eq("Set-Aside (Reviewed from January 01, 2012 to January 10, 2012)")
    end
    it "should print the vote end dates for a Passed proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Passed',
                                           vote_end_date: Date.new(2012, 2, 1))
      expect(prop.status_string).to eq("Passed on February 01, 2012")
    end
    it "should print the vote end dates for a Failde proposal" do
      prop = FactoryGirl.create(:proposal, status: 'Failed',
                                           vote_end_date: Date.new(2012, 2, 1))
      expect(prop.status_string).to eq("Failed on February 01, 2012")
    end
  end

  describe "with 2 revisions" do
    before(:each) do
      @prop = FactoryGirl.create(:proposal)
      @rev1 = FactoryGirl.create(:revision, proposal: @prop)
      @rev2 = FactoryGirl.create(:revision, proposal: @prop)
    end
    it "should return the latest background" do
      expect(@prop.background).to eq(@rev1.background)
    end
    it "should return the latest body" do
      expect(@prop.body).to eq(@rev1.body)
    end
    it "should return the latest references" do
      expect(@prop.references).to eq(@rev1.references)
    end
  end

  describe "with votes" do
    before(:each) do
      @prop = FactoryGirl.create(:proposal)
      @rev1 = FactoryGirl.create(:revision, proposal: @prop)
      @vote = FactoryGirl.create(:vote, proposal: @prop, vote: 'agree', comment: '')

      @cm = FactoryGirl.create(:committee_member, user: @vote.user, committee: @prop.committee)
    end
    it "should count the number of agree votes" do
      expect(@prop.agree_votes).to eq(1)
    end
    it "should count the number of disagree votes" do
      expect(@prop.disagree_votes).to eq(0)
    end
    it "should count the number of abstain votes" do
      expect(@prop.abstain_votes).to eq(0)
    end
    it "should have all voting members (1) voted" do
      expect(@prop.all_voting_members_voted).to eq(true)
    end
    it "should have enough (100%) of the members have voted" do
      expect(@prop.number_of_voting_members).to eq(1)
      expect(@prop.have_voting_quorum).to eq(true)
    end
    it "should have at_least_2/3 agree" do
      expect(@prop.at_least_two_thirds_agree).to eq(true)
    end

    describe "if there is a 2nd committee_members who hasn't voted" do
      before(:each) do
        @cm2 = FactoryGirl.create(:committee_member, committee: @prop.committee)
      end
      it "should have not all voting members (1/2) voted)" do
        expect(@prop.all_voting_members_voted).to eq(false)
      end
      it "should have enough (50%) of the members voted" do
        expect(@prop.number_of_voting_members).to eq(2)
        expect(@prop.have_voting_quorum).to eq(true)
      end
      describe "when the 2nd member votes disagree" do
        before(:each) do
          @vote = FactoryGirl.create(:vote, user: @cm2.user, proposal: @prop, vote: 'disagree', comment: 'hi')
        end
        it "should NOT have at least 2/3 agree" do
          expect(@prop.at_least_two_thirds_agree).to eq(false)
        end
      end

      describe "if there is a 3rd committee_members who hasn't voted" do
        before(:each) do
          FactoryGirl.create(:committee_member, committee: @prop.committee)
        end
        it "should have not all voting members (1/3) voted)" do
          expect(@prop.all_voting_members_voted).to eq(false)
        end
        it "should have enough (33%) of the members voted" do
          expect(@prop.have_voting_quorum).to eq(false)
        end
      end
    end
  end


  describe "with existing Review+Submitted proposals" do
    before(:each) do
      # review proposal which will be advanced
      @p1 = FactoryGirl.create(:proposal, status: 'Review', review_end_date: Date.current.prev_day(1))
      @r1 = FactoryGirl.create(:revision, proposal: @p1)

      # submitted proposal which will not be advanced
      @p2 = FactoryGirl.create(:proposal, status: 'Submitted')
      @r2 = FactoryGirl.create(:revision, proposal: @p2)

      # review proposal which will NOT be advanced (due to date)
      @p3 = FactoryGirl.create(:proposal, status: 'Review', review_end_date: Date.current)
      @r3 = FactoryGirl.create(:revision, proposal: @p3)

      ActionMailer::Base.deliveries.clear
    end
    describe "when I call Proposal.update_states" do
      before(:each) do
        Proposal.update_proposal_states
      end

      it "updates 'Review' proposals that have expired to have status 'Pre-Voting'" do
        @p1.reload
        expect(@p1.status).to eq('Pre-Voting')
      end
      it "doesn't change the 'Submitted' proposal'" do
        @p2.reload
        expect(@p2.status).to eq('Submitted')
      end
      it "doesn't change entries which haven't expired yet" do
        @p3.reload
        expect(@p3.status).to eq('Review')
      end
      it "should send an e-mail when it changes a proposal" do
        num_deliveries = ActionMailer::Base.deliveries.size
        expect(num_deliveries).to eq(1)
      end
    end
  end

  describe "with 'Voting' proposals" do
    before(:each) do
      # voting proposal which will NOT be advanced (due to date)
      @p4 = FactoryGirl.create(:proposal, status: 'Voting', vote_end_date: Date.current)
      @r4 = FactoryGirl.create(:revision, proposal: @p4)

      # voting proposal which will be failed (due to no votes)
      @p5 = FactoryGirl.create(:proposal, status: 'Voting', vote_end_date: Date.current.prev_day(1))
      @r5 = FactoryGirl.create(:revision, proposal: @p5)

      FactoryGirl.create(:committee_member, committee: @p4.committee)
      FactoryGirl.create(:committee_member, committee: @p5.committee)
    end
    describe "when calling update_states" do
      before(:each) do
        ActionMailer::Base.deliveries.clear

        Proposal.update_proposal_states
      end
      it "should not change a proposal if the voting period is not over" do
        @p4.reload
        expect(@p4.status).to eq('Voting')
      end
      it "should mark a proposal as Failed if there are no votes" do
        @p5.reload
        expect(@p5.status).to eq('Failed')
      end
      it "should send an e-mail when it changes a proposal" do
        num_deliveries = ActionMailer::Base.deliveries.size
        expect(num_deliveries).to eq(1)
      end
    end
    describe "calling update_proposal_states when all of the voting-members have voted agree" do
      before(:each) do
        @p5.committee.committee_members.each do |cm|
          FactoryGirl.create(:vote, proposal: @p5, user: cm.user, vote: 'agree')
        end
        ActionMailer::Base.deliveries.clear
        Proposal.update_proposal_states
      end
      it "should mark the proposal as passed" do
        @p5.reload
        expect(@p5.status).to eq('Passed')
      end
      it "should send an e-mail" do
        num_deliveries = ActionMailer::Base.deliveries.size
        expect(num_deliveries).to eq(1)
      end
    end
    describe "calling update_states when all voting-members have voted disagree, but the time has not completed" do
      before(:each) do
        @p4.committee.committee_members.each do |cm|
          FactoryGirl.create(:vote, proposal: @p4, user: cm.user, vote: 'disagree')
        end
        ActionMailer::Base.deliveries.clear
        Proposal.update_proposal_states
      end
      it "should mark the proposal as 'Failed'" do
        @p4.reload
        expect(@p4.status).to eq('Failed')
      end
    end
  end
end
