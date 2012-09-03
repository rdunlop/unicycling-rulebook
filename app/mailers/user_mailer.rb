class UserMailer < ActionMailer::Base
  default from: "unicycling@dunlopweb.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_submitted.subject
  #
  def proposal_submitted
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
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
    @proposal_id = proposal.id.to_s

    subject = "Rulebook Committee 2012 - " + proposal.committee.to_s

    mail to: "robin@dunlopweb.com", subject: subject
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_revised.subject
  #
  def proposal_revised
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
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
  def proposal_status_review
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.vote_changed.subject
  #
  def vote_changed
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
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
  def vote_submitted
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_finished_review.subject
  #
  def proposal_finished_review
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_call_for_voting.subject
  #
  def proposal_call_for_voting
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_voting_result.subject
  #
  def proposal_voting_result
    @greeting = "Hi"

    mail to: "to@dunlopweb.com"
  end
end
