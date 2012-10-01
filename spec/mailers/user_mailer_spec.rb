require "spec_helper"

describe UserMailer do
  before(:each) do
      @comment = FactoryGirl.create(:comment)
      @proposal = @comment.proposal
      FactoryGirl.create(:revision, :proposal => @proposal)
      @user = @comment.user

      @committee = @proposal.committee
      @cm = FactoryGirl.create(:committee_member, :committee => @committee, :user => @user)
      @other_cm_user = FactoryGirl.create(:user)
      @cm2 = FactoryGirl.create(:committee_member, :committee => @committee, :user => @other_cm_user)
      @proposal_id_title_and_committee = "Proposal " + @proposal.id.to_s + " - " + @proposal.title + " for " + @committee.name
  end
  describe "when we have a one no-email super-admin and one normal super-admin" do
    before(:each) do
        @no_email_admin_user = FactoryGirl.create(:admin_user, :no_emails => true)
        @normal_admin_user = FactoryGirl.create(:admin_user)
    end
    it "should only send to the normal admin" do
        mail = UserMailer.proposal_submitted(@proposal)
        mail.to.should eq([@normal_admin_user.email])
    end
  end

  describe "proposal_submitted" do
    before(:each) do
        @admin_user = FactoryGirl.create(:admin_user)
        @admin_user2 = FactoryGirl.create(:admin_user)
    end
    let(:mail) { UserMailer.proposal_submitted(@proposal) }

    it "renders the headers" do
      mail.subject.should eq("New submission of " + @proposal_id_title_and_committee)
      mail.to.should == [@admin_user.email, @admin_user2.email]
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("following proposal has been submitted")
    end
  end

  describe "proposal_comment_added" do
    let(:mail) { UserMailer.proposal_comment_added(@proposal, @comment, @user) }

    it "renders the headers" do
      mail.subject.should eq("Comment Added on " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@comment.comment)
    end
  end

  describe "with a no_emails committee member" do
    before(:each) do
        @other_cm_user.no_emails = true
        @other_cm_user.save
    end
    it "should only e-mail to the normal user" do
        mail = UserMailer.proposal_revised(@proposal)
        mail.to.should eq([@user.email])
    end
  end

  describe "proposal_revised" do
    let(:mail) { UserMailer.proposal_revised(@proposal) }

    it "renders the headers" do
      mail.subject.should eq("Revision to " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("proposal has been revised")
    end
  end

  describe "proposal_status_review" do
    let(:mail) { UserMailer.proposal_status_review(@proposal, true) }

    it "renders the headers" do
      mail.subject.should eq("Proposal in Review: " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("was Set-Aside,")
    end
  end

  describe "vote_changed" do
    let(:mail) { UserMailer.vote_changed(@proposal, @user, 'disagree', 'abstain') }

    it "renders the headers" do
      mail.subject.should eq("Vote Changed on " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("A vote was changed from disagree to abstain by the administrator")
    end
  end

  describe "new_committee_applicant" do
    let(:user) { FactoryGirl.create(:user, :comments => "Please add me") }
    let(:mail) { UserMailer.new_committee_applicant(user) }
    before(:each) do
        @admin_user = FactoryGirl.create(:admin_user)
    end

    it "renders the headers" do
      mail.subject.should eq("New committee applicant")
      mail.to.should eq([@admin_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Here are the details of the new applicant:")
      mail.body.encoded.should match("Please add me")
    end
  end

  describe "vote_submitted" do
    before(:each) do
        @vote = FactoryGirl.create(:vote, :proposal => @proposal)
    end

    let(:mail) { UserMailer.vote_submitted(@vote) }

    it "renders the headers" do
      mail.subject.should eq("Vote Submitted on " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("A member voted on " + @proposal_id_title_and_committee)
      mail.body.encoded.should match("Did you place your vote?")
    end
  end

  describe "proposal_finished_review" do
    let(:mail) { UserMailer.proposal_finished_review(@proposal) }

    it "renders the headers" do
      mail.subject.should eq("Review Period has concluded for " + @proposal_id_title_and_committee)
      mail.to.should eq([@proposal.owner.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Make a revision to the proposal")
    end
  end

  describe "proposal_call_for_voting" do
    let(:mail) { UserMailer.proposal_call_for_voting(@proposal) }

    it "renders the headers" do
      mail.subject.should eq("Call for Voting on " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("read through the latest revision")
    end
  end

  describe "proposal_voting_result" do
    let(:mail) { UserMailer.proposal_voting_result(@proposal, true) }

    it "renders the headers" do
      mail.subject.should eq("Voting Completed for " + @proposal_id_title_and_committee)
      mail.to.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("proposal has Passed")
    end
  end

end
