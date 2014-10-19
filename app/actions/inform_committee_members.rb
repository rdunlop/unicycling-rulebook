class InformCommitteeMembers

  # Send e-mail to all committee members
  # except the originator
  # and those who have opted out
  #
  def self.comment_added(comment)
    emails = committee_members_emails(comment.discussion.committee, comment.user.email)

    if emails.any?
      UserMailer.discussion_comment_added(comment, emails).deliver
    end
  end

  private

  def self.committee_members_emails(committee, exclude)
    committee.committee_members.merge(User.email_notifications).map(&:user).map(&:email) - [exclude]
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
end
