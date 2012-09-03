class UserMailer < ActionMailer::Base
  default from: "unicycling@dunlopweb.com"

  def create_admin_email
    emails = []
    User.all.each do |u|
        if u.admin
            emails << u.email
        end
    end
    emails
  end

  def create_committee_email(committee)
    emails = []
    CommitteeMember.all.each do |cm|
        if cm.committee == committee
            emails << cm.user.email
        end
    end
    emails
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_submitted.subject
  #
  def proposal_submitted(proposal)
    @proposal = proposal
    @body = proposal.latest_revision.body
    @title = proposal.title

    mail to: create_admin_email, subject: 'New submission - Proposal ' + proposal.id.to_s + ' - ' + proposal.title
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_comment_added.subject
  #
  def proposal_comment_added(proposal, comment, user)
    @heading = "Re: (Proposal " + proposal.id.to_s + ") " + proposal.title
    @comment = comment.comment
    @user = user.email
    @voting_status = user.voting_text(proposal.committee)
    @proposal = proposal

    subject = "Rulebook Committee 2012 - " + proposal.committee.to_s

    mail to: create_committee_email(proposal.committee), subject: subject
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

    mail to: create_committee_email(@proposal.committee), subject: '(Proposal ' + proposal.id.to_s + ' New Revision - ' + proposal.title
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_status_voting.subject
  #
  def proposal_status_voting
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
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

    mail to: create_committee_email(@proposal.committee), subject: "(Proposal " + @proposal.id.to_s + ") " + @proposal.title
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.vote_changed.subject
  #
  def vote_changed(user, old_vote_string, new_vote_string)
    @name = user.to_s
    @old_vote = old_vote_string
    @new_vote = new_vote_string

    mail to: "to@dunlopweb.com", subject: "Vote Changed"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_committee_applicant.subject
  #
  def new_committee_applicant
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.vote_submitted.subject
  #
  def vote_submitted(vote)
    @proposal = vote.proposal
    @name = vote.user.to_s

    @committee_name = "Hello" # XXX to be updated
    @vote_text = vote.vote
    @comments = vote.comment

    mail to: "to@dunlopweb.com", subject: "(Proposal "  + @proposal.id.to_s + ") Vote from " + @name + " [" + @proposal.title + "]"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_finished_review.subject
  #
  def proposal_finished_review(proposal)
    @REVISIONTIME_TEXT = "3 days"
    @proposal = proposal

    mail to: proposal.owner.email, subject: 'Proposal has finished the review period'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_call_for_voting.subject
  #
  def proposal_call_for_voting(proposal)
    @proposal = proposal
    @vote_end = proposal.vote_end_date.to_s

    mail to: "to@dunlopweb.com", subject: '(Proposal ' + @proposal.id.to_s + ') Call for voting'
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

    mail to: "to@dunlopweb.com"
  end
end
