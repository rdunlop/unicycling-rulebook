class UserMailer < ActionMailer::Base
  default from: (ENV['MAIL_FULL_EMAIL'] || "unicycling@dunlopweb.com")

  def create_admin_email
    emails = []
    User.all.each do |u|
        if u.admin
            emails << u.email unless u.no_emails
        end
    end
    emails
  end

  def create_committee_email(proposal, committee, honor_no_email = true)
    emails = []
    CommitteeMember.all.each do |cm|
        if cm.committee == committee
          if proposal.nil? or cm.user.can? :read, proposal
            emails << cm.user.email unless (honor_no_email and cm.user.no_emails)
          end
        end
    end
    emails
  end

  def set_threading_header(proposal)
    if not proposal.mail_messageid.nil?
      headers['In-Reply-To'] = proposal.mail_messageid
    end
  end


  def create_proposal_subject(proposal)
    "[" + proposal.committee.to_s + "] " + proposal.title + " (" + proposal.id.to_s + ")"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_submitted.subject
  #
  def proposal_submitted(proposal)
    @proposal = proposal
    @body = proposal.latest_revision.body
    @rule_text = proposal.latest_revision.rule_text
    @title = proposal.title

    mail bcc: create_admin_email, subject: create_proposal_subject(proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_comment_added.subject
  #
  def proposal_comment_added(proposal, comment, user)
    @comment = comment.comment
    @user = user
    @voting_status = user.voting_text(proposal.committee)
    @proposal = proposal

    set_threading_header(proposal)

    mail bcc: create_committee_email(proposal, proposal.committee), subject: create_proposal_subject(proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_revised.subject
  #
  def proposal_revised(proposal)
    @proposal = proposal
    @change_description = proposal.latest_revision.change_description
    @body = proposal.latest_revision.body
    @rule_text = proposal.latest_revision.rule_text

    set_threading_header(proposal)

    mail bcc: create_committee_email(@proposal, @proposal.committee, true), subject: create_proposal_subject(proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_status_review.subject
  #
  def proposal_status_review(proposal, was_tabled)
    @proposal = proposal
    @set_aside_message = was_tabled ? "This proposal was Set-Aside, but has been put back into the review stage." : ""
    @body = @proposal.latest_revision.body
    @rule_text = @proposal.latest_revision.rule_text

    set_threading_header(proposal)

    mail bcc: create_committee_email(@proposal, @proposal.committee), subject: create_proposal_subject(@proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.vote_changed.subject
  #
  def vote_changed(proposal, user, old_vote_string, new_vote_string)
    @name = user.to_s
    @old_vote = old_vote_string
    @new_vote = new_vote_string

    set_threading_header(proposal)

    mail bcc: create_committee_email(proposal, proposal.committee), subject: create_proposal_subject(proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_committee_applicant.subject
  #
  def new_committee_applicant(user)
    @name = user.name
    @email = user.email
    @location = user.location
    @comments = user.comments

    mail bcc: create_admin_email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.vote_submitted.subject
  #
  def vote_submitted(vote)
    @proposal = vote.proposal
    @name = vote.user.to_s

    committee = vote.proposal.committee
    @committee_name = committee.to_s
    @vote_text = vote.vote
    @comments = vote.comment

    set_threading_header(vote.proposal)

    mail bcc: create_committee_email(vote.proposal, committee), subject: create_proposal_subject(@proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_finished_review.subject
  #
  def proposal_finished_review(proposal)
    @REVISIONTIME_TEXT = "3 days"
    @proposal = proposal

    set_threading_header(proposal)

    mail bcc: proposal.owner.email, subject: create_proposal_subject(@proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_call_for_voting.subject
  #
  def proposal_call_for_voting(proposal)
    @proposal = proposal
    @vote_end = proposal.vote_end_date.to_s

    set_threading_header(proposal)

    mail bcc: create_committee_email(@proposal, @proposal.committee), subject: create_proposal_subject(@proposal)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_voting_result.subject
  #
  def proposal_voting_result(proposal, success)
    @proposal = proposal
    @succeeded_failed = success ? "Passed" : "Failed"
    @num_agree = proposal.agree_votes
    @num_disagree = proposal.disagree_votes
    @num_abstain = proposal.abstain_votes

    set_threading_header(proposal)

    mail bcc: create_committee_email(@proposal, @proposal.committee), subject: create_proposal_subject(@proposal)
  end

  def mass_email(committees, subject, body, reply_email)

    emails = []
    committees.each do |c|
        emails += create_committee_email(nil, c, false)
    end
    @body = body

    mail bcc: emails, subject: subject, reply_to: reply_email
  end
end
