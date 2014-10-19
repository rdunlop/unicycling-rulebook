class InformAdminUsers

  # send an e-mail to all Admin users
  def self.new_applicant(user)
    if admin_emails.any?
      UserMailer.new_committee_applicant(user, admin_emails).deliver
    end
  end

  def self.admin_emails
    User.admin.email_notifications.map(&:email)
  end
end
