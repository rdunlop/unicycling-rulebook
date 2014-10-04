class UserMailerPreview < ActionMailer::Preview

  def proposal_submitted
    UserMailer.proposal_submitted(proposal)
  end

  def discussion_comment_added
    UserMailer.discussion_comment_added(discussion, comment, user)
  end

  def proposal_revised
    UserMailer.proposal_revised(proposal)
  end

  def proposal_status_review
    was_tabled = [true, false].sample
    UserMailer.proposal_status_review(proposal, was_tabled)
  end

  def vote_changed
    old_vote_string = "agree"
    new_vote_string = "disagree"
    UserMailer.vote_changed(proposal, user, old_vote_string, new_vote_string)
  end

  def new_committee_applicant
    UserMailer.new_committee_applicant(user)
  end

  def vote_submitted
    UserMailer.vote_submitted(vote)
  end

  def proposal_finished_review
    UserMailer.proposal_finished_review(proposal)
  end

  def proposal_call_for_voting
    UserMailer.proposal_call_for_voting(proposal)
  end

  def proposal_voting_result
    success = [true, false].sample
    UserMailer.proposal_voting_result(proposal, success)
  end

  def mass_email
    committees = [committee]
    subject = "This is a mass e-mail"
    body = "Hello, this is a mass e-mail to all"
    reply_email = "robin@test.com"

    UserMailer.mass_email(committees, subject, body, reply_email)
  end

  private

  def proposal
    return @proposal if @proposal
    @proposal = Proposal.new
    @proposal.committee = committee
    @proposal.owner = user
    @proposal.title = "Change the rule"
    @proposal.status = "Submitted"
    create_revision(@proposal)
    @proposal
  end

  def create_revision(proposal)
    revision = Revision.new
    revision.proposal = proposal
    revision.body = "Rule body"
    revision.user = user
    revision
  end

  def comment
    @comment ||= Comment.new
  end

  def user
    return @user if @user
    @user = User.new
    @user.email = "robin#{user_number}@test.com"
    @user.name = "Robin"
    @user.password = "password"
    @user
  end

  def discussion
    return @discussion if @discussion
    @discussion = Discussion.new(title: "this is the discussion", body: "<p>This is the <b>Discussion body</b></p")
  end

  def user_number
    @user_number ||= 0
    @user_number = @user_number + 1
  end

  def committee
    return @committee if @committee
    @committee = Committee.new
    @committee.name = "Basic Committee #{user_number}"
    @committee
  end

  def vote
    @vote ||= Vote.new
    @vote.proposal = proposal
    @vote
  end
end
