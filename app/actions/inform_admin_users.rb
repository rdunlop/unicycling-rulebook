class InformAdminUsers

  # send an e-mail to all Admin users
  def self.new_applicant(user)
    if admin_emails.any?
      UserMailer.new_committee_applicant(user, admin_emails).deliver_later
    end
  end

  # send an -email to all admins,
  # and also set the mail_message_id for the proposal
  # so that future e-mails are all threaded similarly
  def self.submit_proposal(proposal)
    if admin_emails.any?
      UserMailer.proposal_submitted(proposal, admin_emails).deliver_later
    end
  end

  def self.admin_emails
    User.admin.email_notifications.map(&:email)
  end
  private_class_method :admin_emails
end
