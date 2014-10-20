class UserMailer < ActionMailer::Base
  default :return_path => (Rails.application.secrets.mail_full_email || "unicycling@dunlopweb.com")
  before_action :set_rulebook_slug

  def set_rulebook_slug
    default_url_options[:rulebook_slug] = Apartment::Tenant.current
  end

  def create_from(from_name = Rails.application.secrets.mail_from_name, from_email = Rails.application.secrets.mail_full_email)
    if from_email.nil?
      from_email = "unicycling@dunlopweb.com"
    end
    if from_name.nil?
      from_string = from_email
    else
      from_string = "\"#{from_name}\" <#{from_email}>"
    end
    from_string
  end

  def send_mail(bcc_list, proposal, from_name)
    mail bcc: bcc_list, subject: create_proposal_subject(proposal), from: create_from(from_name)
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
    "[" + proposal.committee.to_s + "] " + proposal.title + " (#" + proposal.id.to_s + ")"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_submitted.subject
  #
  def proposal_submitted(proposal, admin_emails)
    @proposal = proposal
    @body = proposal.latest_revision.body
    @rule_text = proposal.latest_revision.rule_text
    @title = proposal.title

    send_mail(admin_emails, proposal, proposal.owner.name)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.discussion_comment_added.subject
  #
  def discussion_comment_added(comment, members_emails)
    @comment = comment.comment
    @voting_status = comment.user.voting_text(comment.discussion.committee)
    @discussion = comment.discussion

    #set_threading_header(proposal)

    send_mail(members_emails, @discussion, comment.user.name)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_revised.subject
  #
  def proposal_revised(revision, members_emails)
    @proposal = revision.proposal
    @change_description = revision.change_description
    @body = revision.body
    @rule_text = revision.rule_text

    set_threading_header(@proposal)

    send_mail(members_emails, @proposal, revision.user.name)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_status_review.subject
  #
  def proposal_status_review(proposal, was_tabled, members_emails)
    @proposal = proposal
    @set_aside_message = was_tabled ? "This proposal was Set-Aside, but has been put back into the review stage." : ""
    @body = @proposal.latest_revision.body
    @rule_text = @proposal.latest_revision.rule_text

    set_threading_header(proposal)

    send_mail(members_emails, @proposal, nil)
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

    send_mail(create_committee_email(proposal, proposal.committee), proposal, nil)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_committee_applicant.subject
  #
  def new_committee_applicant(user, admin_emails)
    @name = user.name
    @email = user.email
    @location = user.location
    @comments = user.comments

    mail bcc: admin_emails, from: create_from
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.vote_submitted.subject
  #
  def vote_submitted(vote)
    @proposal = vote.proposal
    @proposal.reload # get new vote associations
    @name = vote.user.to_s

    committee = @proposal.committee
    @committee_name = committee.to_s
    @vote_text = vote.vote
    @comments = vote.comment

    set_threading_header(@proposal)

    # don't send e-mails to people who have already voted
    all_possible_emails = create_committee_email(@proposal, committee)
    already_voted_emails = @proposal.votes.map {|v| v.user.email }
    # don't include non-voting members in the e-mail list
    non_voting_emails = @proposal.committee.committee_members.select { |cm| cm.voting == false}.map {|cm| cm.user.email}

    emails = all_possible_emails - already_voted_emails
    emails = emails - non_voting_emails

    send_mail(emails, vote.proposal, nil)
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

    mail bcc: proposal.owner.email, subject: create_proposal_subject(@proposal), from: create_from
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.proposal_call_for_voting.subject
  #
  def proposal_call_for_voting(proposal, members_emails)
    @proposal = proposal
    @vote_end = proposal.vote_end_date.to_s

    set_threading_header(proposal)

    send_mail(members_emails, @proposal, nil)
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

    send_mail(create_committee_email(@proposal, @proposal.committee), @proposal, nil)
  end

  def mass_email(committees, subject, body, reply_email)

    emails = []
    committees.each do |c|
      emails += create_committee_email(nil, c, false)
    end
    @body = body

    mail bcc: emails, subject: subject, reply_to: reply_email, from: create_from
  end
end
