require "spec_helper"

describe UserMailer do
  describe "proposal_submitted" do
    let(:mail) { UserMailer.proposal_submitted }

    it "renders the headers" do
      mail.subject.should eq("Proposal submitted")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "proposal_comment_added" do
    before(:each) do
        @comment = FactoryGirl.create(:comment)
        @proposal = @comment.proposal
        @user = @comment.user

        @committee = @proposal.committee
    end
    let(:mail) { UserMailer.proposal_comment_added(@proposal, @comment, @user) }

    it "renders the headers" do
      mail.subject.should eq("Rulebook Committee 2012 - " + @committee.name)
      mail.to.should eq(["robin@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should eq(
        "Re: (Proposal " + @proposal.id.to_s + ") " + @proposal.title + "\r\n\r\n" +
        @comment.comment + "\r\n\r\n\r\n--\r\n" + @user.to_s + " - " +
        "Non-Voting Member" + "__________________________________________________________\r\n" +
        "Proposal " + @proposal.id.to_s + " can be viewed at:\r\n" +
        "http://localhost:8080/proposals/" + @proposal.id.to_s + "\r\n")
    end
  end

  describe "proposal_revised" do
    let(:mail) { UserMailer.proposal_revised }

    it "renders the headers" do
      mail.subject.should eq("Proposal revised")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "proposal_status_voting" do
    let(:mail) { UserMailer.proposal_status_voting }

    it "renders the headers" do
      mail.subject.should eq("Proposal status voting")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "proposal_status_review" do
    let(:mail) { UserMailer.proposal_status_review }

    it "renders the headers" do
      mail.subject.should eq("Proposal status review")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "vote_changed" do
    let(:mail) { UserMailer.vote_changed }

    it "renders the headers" do
      mail.subject.should eq("Vote changed")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "new_committee_applicant" do
    let(:mail) { UserMailer.new_committee_applicant }

    it "renders the headers" do
      mail.subject.should eq("New committee applicant")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "vote_submitted" do
    let(:mail) { UserMailer.vote_submitted }

    it "renders the headers" do
      mail.subject.should eq("Vote submitted")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "proposal_finished_review" do
    let(:mail) { UserMailer.proposal_finished_review }

    it "renders the headers" do
      mail.subject.should eq("Proposal finished review")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "proposal_call_for_voting" do
    let(:mail) { UserMailer.proposal_call_for_voting }

    it "renders the headers" do
      mail.subject.should eq("Proposal call for voting")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "proposal_voting_result" do
    let(:mail) { UserMailer.proposal_voting_result }

    it "renders the headers" do
      mail.subject.should eq("Proposal voting result")
      mail.to.should eq(["to@dunlopweb.com"])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
