require "spec_helper"

describe UserMailer do
  before(:each) do
      @proposal = FactoryGirl.create(:proposal, :status => "Review", :title => 'A "very" strange title')
      @proposal.mail_messageid = "mymessageid"
      @comment = FactoryGirl.create(:comment, :proposal => @proposal, :comment => 'This is what I "Said"')
      FactoryGirl.create(:revision, :proposal => @proposal, :rule_text => "This is what I \"Like\" to do", :body => "Sometimes I <link> somewhere")
      @user = @comment.user

      @committee = @proposal.committee
      @cm = FactoryGirl.create(:committee_member, :committee => @committee, :user => @user)
      @other_cm_user = FactoryGirl.create(:user)
      @cm2 = FactoryGirl.create(:committee_member, :committee => @committee, :user => @other_cm_user)
      @proposal_id_title_and_committee = "[" + @committee.name + "] " + @proposal.title + " (#" + @proposal.id.to_s + ")"
  end
  describe "when we have a one no-email super-admin and one normal super-admin" do
    before(:each) do
        @no_email_admin_user = FactoryGirl.create(:admin_user, :no_emails => true)
        @normal_admin_user = FactoryGirl.create(:admin_user)
    end
    it "should only send to the normal admin" do
        mail = UserMailer.proposal_submitted(@proposal)
        mail.bcc.should eq([@normal_admin_user.email])
    end
  end

  describe "proposal_submitted" do
    before(:each) do
        @admin_user = FactoryGirl.create(:admin_user)
        @admin_user2 = FactoryGirl.create(:admin_user)
    end
    let(:mail) { UserMailer.proposal_submitted(@proposal) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@admin_user.email, @admin_user2.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("following proposal has been submitted")
    end
    it "renders the body without screwing up quotes" do
      mail.body.encoded.should match('A "very" strange title')
      mail.body.encoded.should match('This is what I "Like" to do')
      mail.body.encoded.should match("Sometimes I <link> somewhere")
    end
    it "should not have a in-reply-to set" do
      mail['In-Reply-To'].should be_nil
    end
  end

  describe "proposal_comment_added" do
    let(:mail) { UserMailer.proposal_comment_added(@proposal, @comment, @user) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Comment Added")
      mail.body.encoded.should match('This is what I "Said"')
      mail.body.encoded.should match(@comment.comment)
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end
  end
  describe "'Submitted' Proposal commented on" do
    before (:each) do
      @proposal.status = "Submitted"
      @proposal.save
    end
    let(:mail) { UserMailer.proposal_comment_added(@proposal, @comment, @user) }

    it "should not send e-mail to members if the proposal is in 'Submitted' state" do
      @proposal.status.should == "Submitted"
      mail.bcc.should eq([])
    end
  end
  describe "Proposal without mail_messageid commented on" do
    before(:each) do
      @proposal.mail_messageid = nil
      @proposal.save
    end
    let(:mail) { UserMailer.proposal_comment_added(@proposal, @comment, @user) }

    it "should have the body" do
      mail.body.encoded.should match("Comment Added")
    end
    it "should have no in-reply-to set" do
      mail['In-Reply-To'].should be_nil
    end
  end

  describe "with a no_emails committee member" do
    before(:each) do
        @other_cm_user.no_emails = true
        @other_cm_user.save
    end
    it "should only e-mail.bcc the normal user" do
        mail = UserMailer.proposal_revised(@proposal)
        mail.bcc.should eq([@user.email])
    end
  end

  describe "'Submitted' Proposal Revised" do
    before (:each) do
      @proposal.status = "Submitted"
      @proposal.save
    end
    let(:mail) { UserMailer.proposal_revised(@proposal) }

    it "should not send e-mail to members if the proposal is in 'Submitted' state" do
      @proposal.status.should == "Submitted"
      mail.bcc.should eq([])
    end
  end

  describe "'Review' proposal_revised" do
    let(:mail) { UserMailer.proposal_revised(@proposal) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("proposal has been revised")
    end
    it "renders the body without screwing up quotes" do
      mail.body.encoded.should match('This is what I "Like" to do')
      mail.body.encoded.should match("Sometimes I <link> somewhere")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end
  end

  describe "proposal_status_review" do
    let(:mail) { UserMailer.proposal_status_review(@proposal, true) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Proposal in Review")
      mail.body.encoded.should match("was Set-Aside,")
    end
    it "renders the body without screwing up quotes" do
      mail.body.encoded.should match('This is what I "Like" to do')
      mail.body.encoded.should match("Sometimes I <link> somewhere")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end
  end

  describe "vote_changed" do
    let(:mail) { UserMailer.vote_changed(@proposal, @user, 'disagree', 'abstain') }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("A vote was changed from disagree to abstain by the administrator")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
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
      mail.bcc.should eq([@admin_user.email])
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
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("A member Voted")
      mail.body.encoded.should match("Did you place your vote?")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end

    it "should not send e-mail to people who have voted" do
      @my_vote = FactoryGirl.create(:vote, :proposal => @proposal, :user => @user)
      mail.bcc.should eq([@other_cm_user.email])
    end
  end

  describe "proposal_finished_review" do
    let(:mail) { UserMailer.proposal_finished_review(@proposal) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@proposal.owner.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Review Period has concluded")
      mail.body.encoded.should match("Make a revision to the proposal")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end
  end

  describe "proposal_call_for_voting" do
    let(:mail) { UserMailer.proposal_call_for_voting(@proposal) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Call for Voting")
      mail.body.encoded.should match("read through the latest revision")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end
  end

  describe "proposal_voting_result" do
    let(:mail) { UserMailer.proposal_voting_result(@proposal, true) }

    it "renders the headers" do
      mail.subject.should eq(@proposal_id_title_and_committee)
      mail.bcc.should eq([@user.email, @other_cm_user.email])
      mail.from.should eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Voting Completed")
      mail.body.encoded.should match("proposal has Passed")
    end
    it "should have a in-reply-to set" do
      mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    end
  end

  describe "mass_email" do
    let(:mail) { UserMailer.mass_email([@committee], 'Some Subject', 'Some text', "some@dunlopweb.com") }

    it "uses bcc for all committee members" do
      mail.subject.should eq("Some Subject")
      mail.bcc.should eq([@user.email, @other_cm_user.email])
    end
    it "sends e-mail even when the user is set to 'no-email'" do
      @user3 = FactoryGirl.create(:user, :no_emails => true)
      @cm = FactoryGirl.create(:committee_member, :committee => @committee, :user => @user3)
      mail.subject.should eq("Some Subject")
      mail.bcc.should eq([@user.email, @other_cm_user.email, @user3.email])
    end
    it "should be sent with the specified 'reply-to' address" do
      mail.reply_to.should eq(["some@dunlopweb.com"])
    end
  end

end
