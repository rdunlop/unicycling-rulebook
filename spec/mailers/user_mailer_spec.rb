require "spec_helper"

describe UserMailer, :type => :mailer do
  before(:each) do
      @proposal = FactoryGirl.create(:proposal, :status => "Review", :title => 'A "very" strange title', :mail_messageid => "mymessageid")
      @discussion = FactoryGirl.create(:discussion, proposal: @proposal, committee: @proposal.committee)
      @comment = FactoryGirl.create(:comment, :discussion => @discussion, :comment => 'This is what I "Said"')
      FactoryGirl.create(:revision, :proposal => @proposal, :rule_text => "This is what I \"Like\" to do", :body => "Sometimes I <link> somewhere")
      @user = @comment.user

      @committee = @proposal.committee
      @cm = FactoryGirl.create(:committee_member, :committee => @committee, :user => @user)
      @other_cm_user = FactoryGirl.create(:user)
      @cm2 = FactoryGirl.create(:committee_member, :committee => @committee, :user => @other_cm_user)
      @proposal_id_title_and_committee = "[" + @committee.name + "] " + @proposal.title + " (#" + @proposal.id.to_s + ")"
  end

  describe "proposal_submitted" do
    let(:admin_user) { FactoryGirl.create(:admin_user) }
    let(:mail) { UserMailer.proposal_submitted(@proposal, [admin_user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.bcc).to eq([admin_user.email])
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
      expect(mail.header[:from].to_s).to eq("#{@proposal.owner.name} <unicycling@dunlopweb.com>")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("following proposal has been submitted")
    end
    it "renders the body without screwing up quotes" do
      expect(mail.body.encoded).to match('A "very" strange title')
      expect(mail.body.encoded).to match('This is what I "Like" to do')
      expect(mail.body.encoded).to match("Sometimes I <link> somewhere")
    end
    it "should not have a in-reply-to set" do
      expect(mail['In-Reply-To']).to be_nil
    end
  end

  describe "discussion_comment_added" do
    let(:mail) { UserMailer.discussion_comment_added(@comment, [@user.email]) }

    it "renders the headers" do
      #mail.subject.should eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
      expect(mail.header[:from].to_s).to eq("#{@user} <unicycling@dunlopweb.com>")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Comment Added")
      expect(mail.body.encoded).to match('This is what I "Said"')
      expect(mail.body.encoded).to match(@comment.comment)
    end
    #it "should have a in-reply-to set" do
    #  mail['In-Reply-To'].to_s.should == @proposal.mail_messageid
    #end
  end

  describe "Proposal without mail_messageid commented on" do
    before(:each) do
      @proposal.mail_messageid = nil
      @proposal.save
    end
    let(:mail) { UserMailer.discussion_comment_added(@comment, [@user.email]) }

    it "should have the body" do
      expect(mail.body.encoded).to match("Comment Added")
    end
    it "should have no in-reply-to set" do
      expect(mail['In-Reply-To']).to be_nil
    end
  end

  describe "'Review' proposal_revised" do
    let(:mail) { UserMailer.proposal_revised(@proposal.latest_revision, [@user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("proposal has been revised")
    end
    it "renders the body without screwing up quotes" do
      expect(mail.body.encoded).to match('This is what I "Like" to do')
      expect(mail.body.encoded).to match("Sometimes I <link> somewhere")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "proposal_status_review" do
    let(:mail) { UserMailer.proposal_status_review(@proposal, true, [@user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Proposal in Review")
      expect(mail.body.encoded).to match("was Set-Aside,")
    end
    it "renders the body without screwing up quotes" do
      expect(mail.body.encoded).to match('This is what I "Like" to do')
      expect(mail.body.encoded).to match("Sometimes I <link> somewhere")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "vote_changed" do
    let(:mail) { UserMailer.vote_changed(@proposal, @user, 'disagree', 'abstain', [@user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("A vote was changed from disagree to abstain by the administrator")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "new_committee_applicant" do
    let(:user) { FactoryGirl.create(:user, :comments => "Please add me") }
    let(:admin_user) { FactoryGirl.create(:admin_user) }
    let(:mail) { UserMailer.new_committee_applicant(user, [admin_user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq("New committee applicant")
      expect(mail.bcc).to eq([admin_user.email])
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
      expect(mail.header[:from].to_s).to eq("Uni Rulebook <unicycling@dunlopweb.com>")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Here are the details of the new applicant:")
      expect(mail.body.encoded).to match("Please add me")
    end
  end

  describe "vote_submitted" do
    before(:each) do
        @vote = FactoryGirl.create(:vote, :proposal => @proposal)
    end

    let(:mail) { UserMailer.vote_submitted(@vote, [@user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("A member Voted")
      expect(mail.body.encoded).to match("Did you place your vote?")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "proposal_finished_review" do
    let(:mail) { UserMailer.proposal_finished_review(@proposal) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.bcc).to eq([@proposal.owner.email])
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Review Period has concluded")
      expect(mail.body.encoded).to match("Make a revision to the proposal")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "proposal_call_for_voting" do
    let(:mail) { UserMailer.proposal_call_for_voting(@proposal, [@user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Call for Voting")
      expect(mail.body.encoded).to match("read through the latest revision")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "proposal_voting_result" do
    let(:mail) { UserMailer.proposal_voting_result(@proposal, true, [@user.email]) }

    it "renders the headers" do
      expect(mail.subject).to eq(@proposal_id_title_and_committee)
      expect(mail.from).to eq(["unicycling@dunlopweb.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Voting Completed")
      expect(mail.body.encoded).to match("proposal has Passed")
    end
    it "should have a in-reply-to set" do
      expect(mail['In-Reply-To'].to_s).to eq(@proposal.mail_messageid)
    end
  end

  describe "mass_email" do
    let(:mail) { UserMailer.mass_email([@committee.id], 'Some Subject', 'Some text', "some@dunlopweb.com") }

    it "uses bcc for all committee members" do
      expect(mail.subject).to eq("Some Subject")
      expect(mail.bcc).to match_array([@user.email, @other_cm_user.email])
    end
    it "sends e-mail even when the user is set to 'no-email'" do
      @user3 = FactoryGirl.create(:user, :no_emails => true)
      @cm = FactoryGirl.create(:committee_member, :committee => @committee, :user => @user3)
      expect(mail.subject).to eq("Some Subject")
      expect(mail.bcc).to eq([@user.email, @other_cm_user.email, @user3.email])
    end
    it "should be sent with the specified 'reply-to' address" do
      expect(mail.reply_to).to eq(["some@dunlopweb.com"])
    end
  end

end
