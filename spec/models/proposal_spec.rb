require 'spec_helper'

describe Proposal do
  it "should have an associated user" do
    prop = Proposal.new
    prop.committee = FactoryGirl.create(:committee)
    prop.title = "Hello People"
    prop.status = 'Submitted'
    prop.valid?.should == false

    prop.owner = FactoryGirl.create(:user)
    prop.valid?.should == true
  end

  it "must have a title" do
    prop = Proposal.new
    prop.status = 'Submitted'
    prop.owner = FactoryGirl.create(:user)
    prop.committee = FactoryGirl.create(:committee)
    prop.valid?.should == false

    prop.title = "Hi there"
    prop.valid?.should == true
  end

  it "should have an associated committee" do
    prop = Proposal.new
    prop.status = 'Submitted'
    prop.title = "Hello People"
    prop.owner = FactoryGirl.create(:user)
    prop.valid?.should == false

    prop.committee = FactoryGirl.create(:committee)
    prop.valid?.should == true
  end

  it "should return its title as the default string" do
    prop = FactoryGirl.create(:proposal)

    prop.to_s.should == prop.title
  end

  it "should have associated votes" do
    proposal = FactoryGirl.create(:proposal)
    vote = FactoryGirl.create(:vote, :proposal => proposal)

    prop = Proposal.find(proposal.id)

    prop.votes.count.should == 1
  end

  it "should have associated comments" do
    proposal = FactoryGirl.create(:proposal)
    vote = FactoryGirl.create(:comment, :proposal => proposal)

    prop = Proposal.find(proposal.id)

    prop.comments.count.should == 1
  end

  it "should only allow certain status values" do
    proposal = FactoryGirl.create(:proposal)
    proposal.valid?.should == true

    proposal.status = "Submitted"
    proposal.valid?.should == true
    proposal.status = "Review"
    proposal.valid?.should == true
    proposal.status = "Pre-Voting"
    proposal.valid?.should == true
    proposal.status = "Voting"
    proposal.valid?.should == true
    proposal.status = "Tabled"
    proposal.valid?.should == true
    proposal.status = "Passed"
    proposal.valid?.should == true
    proposal.status = "Failed"
    proposal.valid?.should == true
    proposal.status = "Robin"
    proposal.valid?.should == false
  end

  it "should have a latest_revision_number" do
    revision = FactoryGirl.create(:revision)
    prop = revision.proposal

    prop.latest_revision_number.should == revision.num
  end
  it "should provide all revisions in descending order" do
    prop = FactoryGirl.create(:proposal)
    rev1 = FactoryGirl.create(:revision, :proposal => prop)
    rev2 = FactoryGirl.create(:revision, :proposal => prop)

    prop.revisions.should == [rev2, rev1]
  end

  describe "when checking the 'status_string'" do
    it "should print only the status for a Submitted proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Submitted')
        prop.status_string.should == "Submitted"
    end
    it "should print the review dates for a Review proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Review', 
                                             :review_start_date => DateTime.civil_from_format(:local, 2012, 1, 1),
                                             :review_end_date   => DateTime.civil_from_format(:local, 2012, 1, 10))
        prop.status_string.should == "Review from January  1, 2012 to January 10, 2012"
    end

    it "should print the review dates for a Pre-Voting proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Pre-Voting', 
                                             :review_start_date => DateTime.civil_from_format(:local, 2012, 1, 1),
                                             :review_end_date   => DateTime.civil_from_format(:local, 2012, 1, 10))
        prop.status_string.should == "Pre-Voting (Reviewed from January  1, 2012 to January 10, 2012)"
    end
    it "should print the voting dates for a Voting proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Voting', 
                                             :vote_start_date => DateTime.civil_from_format(:local, 2012, 1, 1),
                                             :vote_end_date   => DateTime.civil_from_format(:local, 2012, 1, 10))
        prop.status_string.should == "Voting from January  1, 2012 to January 10, 2012"
    end
    it "should print the review dates for a Tabled proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Tabled', 
                                             :review_start_date => DateTime.civil_from_format(:local, 2012, 1, 1),
                                             :review_end_date   => DateTime.civil_from_format(:local, 2012, 1, 10))
        prop.status_string.should == "Set-Aside (Reviewed from January  1, 2012 to January 10, 2012)"
    end
    it "should print the vote end dates for a Passed proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Passed', 
                                             :vote_end_date => DateTime.civil_from_format(:local, 2012, 2, 1))
        prop.status_string.should == "Passed on February  1, 2012"
    end
    it "should print the vote end dates for a Failde proposal" do
        prop = FactoryGirl.create(:proposal, :status => 'Failed', 
                                             :vote_end_date => DateTime.civil_from_format(:local, 2012, 2, 1))
        prop.status_string.should == "Failed on February  1, 2012"
    end
  end

  describe "with 2 revisions" do
    before(:each) do
        @prop = FactoryGirl.create(:proposal)
        @rev1 = FactoryGirl.create(:revision, :proposal => @prop)
        @rev2 = FactoryGirl.create(:revision, :proposal => @prop)
    end
    it "should return the latest background" do
        @prop.background.should == @rev1.background
    end
    it "should return the latest body" do
        @prop.body.should == @rev1.body
    end
    it "should return the latest references" do
        @prop.references.should == @rev1.references
    end
  end

  describe "with votes" do
    before(:each) do
        @prop = FactoryGirl.create(:proposal)
        @rev1 = FactoryGirl.create(:revision, :proposal => @prop)
        @vote = FactoryGirl.create(:vote, :proposal => @prop, :vote => 'agree', :comment => '')
    end
    it "should count the number of agree votes" do
        @prop.agree_votes.should == 1
    end
    it "should count the number of disagree votes" do
        @prop.disagree_votes.should == 0
    end
    it "should count the number of abstain votes" do
        @prop.abstain_votes.should == 0
    end
  end


  describe "with existing proposals" do
    before(:each) do
        # review proposal which will be advanced
        @p1 = FactoryGirl.create(:proposal, :status => 'Review', :review_end_date => Time.now - 1.minute)
        @r1 = FactoryGirl.create(:revision, :proposal => @p1)

        # submitted proposal which will not be advanced
        @p2 = FactoryGirl.create(:proposal, :status => 'Submitted')
        @r2 = FactoryGirl.create(:revision, :proposal => @p2)

        # review proposal which will NOT be advanced (due to date)
        @p3 = FactoryGirl.create(:proposal, :status => 'Review', :review_end_date => Time.now + 3.days)
        @r3 = FactoryGirl.create(:revision, :proposal => @p3)

        ActionMailer::Base.deliveries.clear
    end
    describe "when I call Proposal.update_states" do
        before(:each) do
            Proposal.update_states
        end

        it "updates 'Review' proposals that have expired to have status 'Pre-Voting'" do
            @p1.reload
            @p1.status.should == 'Pre-Voting'
        end
        it "doesn't change the 'Submitted' proposal'" do
            @p2.reload
            @p2.status.should == 'Submitted'
        end
        it "doesn't change entries which haven't expired yet" do
            @p3.reload
            @p3.status.should == 'Review'
        end
        it "should send an e-mail when it changes a proposal" do
            num_deliveries = ActionMailer::Base.deliveries.size
            num_deliveries.should == 1
        end

    end
  end
end
