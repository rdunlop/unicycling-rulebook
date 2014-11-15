class InformCommitteeMembers

  # Send e-mail to all committee members
  # except the originator
  # and those who have opted out
  #
  def self.comment_added(comment)
    if comment.discussion.try(:proposal).try(:status) == "Submitted"
      emails = committee_admin_members_emails(comment.discussion.committee, comment.user.email)
    else
      emails = committee_members_emails(comment.discussion.committee, comment.user.email)
    end

    UserMailer.delay.discussion_comment_added(comment.id, emails) unless emails.none?
  end

  # Send e-mail to all committee members
  # except the originator
  # If the proposal is in "Submitted" state, only inform the committee admins, not regular users
  def self.proposal_revised(revision)
    if revision.proposal.status == "Submitted"
      emails = committee_admin_members_emails(revision.proposal.committee, revision.user.email)
    else
      emails = committee_members_emails(revision.proposal.committee, revision.user.email)
    end

    UserMailer.delay.proposal_revised(revision.id, emails) unless emails.none?
  end

  def self.proposal_call_for_voting(proposal)
    emails = committee_members_emails(proposal.committee, nil)

    UserMailer.delay.proposal_call_for_voting(proposal.id, emails) unless emails.none?
  end

  def self.proposal_status_review(proposal, was_tabled)
    emails = committee_members_emails(proposal.committee, nil)

    UserMailer.delay.proposal_status_review(proposal, was_tabled, emails) unless emails.none?
  end

  def self.vote_submitted(vote)
    emails = committee_members_emails(vote.proposal.committee, nil)

    # don't send e-mails to people who have already voted
    all_possible_emails = emails
    already_voted_emails = vote.proposal.votes.map {|v| v.user.email }
    # don't include non-voting members in the e-mail list
    non_voting_emails = vote.proposal.committee.committee_members.select { |cm| cm.voting == false}.map {|cm| cm.user.email}

    emails = all_possible_emails - already_voted_emails
    emails = emails - non_voting_emails


    UserMailer.vote_submitted(vote, emails).deliver unless emails.none?
  end

  def self.vote_changed(proposal, current_user, previous_value, new_vote_value)
    emails = committee_members_emails(proposal.committee, nil)

    UserMailer.vote_changed(proposal, current_user, previous_value, new_vote_value, emails).deliver unless emails.none?
  end

  def self.proposal_voting_result(proposal, status)
    emails = committee_members_emails(proposal.committee, nil)

    UserMailer.proposal_voting_result(proposal, status, emails).deliver unless emails.none?
  end

  private

  def self.committee_members_emails(committee, exclude)
    committee.committee_members.merge(User.email_notifications).map(&:user).map(&:email) - [exclude]
  end

  def self.committee_admin_members_emails(committee, exclude)
    committee.committee_members.admin.merge(User.email_notifications).map(&:user).map(&:email) - [exclude]
  end
end
