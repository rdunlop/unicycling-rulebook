class UserMailerPreview < ActionMailer::Preview

  # Switch to a tenant so that we have data
  def initialize
    Apartment::Tenant.switch! Rulebook.first.subdomain
  end

  def proposal_submitted
    UserMailer.proposal_submitted(proposal, admin_emails)
  end

  def discussion_created
    UserMailer.discussion_created(discussion, committee_emails)
  end

  def discussion_comment_added
    UserMailer.discussion_comment_added(comment, committee_emails)
  end

  def proposal_revised
    UserMailer.proposal_revised(revision, committee_emails)
  end

  def proposal_status_review
    was_tabled = [true, false].sample
    UserMailer.proposal_status_review(proposal, was_tabled, committee_emails)
  end

  def vote_changed
    old_vote_string = "agree"
    new_vote_string = "disagree"
    UserMailer.vote_changed(proposal, user, old_vote_string, new_vote_string, committee_emails)
  end

  def new_committee_applicant
    UserMailer.new_committee_applicant(user, admin_emails)
  end

  def vote_submitted
    UserMailer.vote_submitted(vote, committee_emails)
  end

  def proposal_finished_review
    UserMailer.proposal_finished_review(proposal)
  end

  def proposal_call_for_voting
    UserMailer.proposal_call_for_voting(proposal, committee_emails)
  end

  def proposal_voting_result
    success = [true, false].sample
    UserMailer.proposal_voting_result(proposal, success, committee_emails)
  end

  def mass_email
    committees = [committee.id]
    subject = "This is a mass e-mail"
    body = "Hello, this is a mass e-mail to all"
    reply_email = "robin@test.com"

    UserMailer.mass_email(committees, subject, body, reply_email)
  end

  private

  def proposal
    return @proposal if @proposal
    @proposal = Proposal.all.sample
  end

  def revision
    @revision ||= Revision.where.not(change_description: nil).sample
  end

  def comment
    @comment ||= Comment.all.sample
  end

  def user
    return @user if @user
    @user = User.all.sample
  end

  def discussion
    return @discussion if @discussion
    @discussion = Discussion.all.sample
  end

  def user_number
    @user_number ||= 0
    @user_number = @user_number + 1
  end

  def committee
    return @committee if @committee
    @committee = Committee.all.sample
  end

  def vote
    @vote ||= Vote.all.sample
  end

  def admin_emails
    ["admin2@gmail.com"]
  end

  def committee_emails
    ["boring_user1@gmail.com", "boring_user2@gmail.com"]
  end
end
