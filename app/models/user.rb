# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE), not null
#  name                   :string
#  location               :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  comments               :text
#  no_emails              :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  attr_accessor :confirming # indicates that we are about to confirm this user

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :committee_members, inverse_of: :user
  has_many :committees, through: :committee_members
  has_many :votes
  has_many :discussion_comments, class_name: "Comment"

  scope :admin, -> { where(admin: true) }
  scope :email_notifications, -> { where(no_emails: false).where.not(confirmed_at: nil) }

  after_commit :send_email_to_admins, on: :create

  after_initialize :init

  # allow initial creation to occur without a name
  validates_presence_of :name, if: :confirming_or_confirmed?

  def confirming_or_confirmed?
    confirming || confirmed?
  end

  # necessary to allow user creation without password
  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  # Cause devise mail to be sent asynchronously
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && password.present?
  end

  def init
    self.no_emails = false if self.no_emails.nil?
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def send_email_to_admins
    InformAdminUsers.new_applicant(self)
  end

  def accessible_committees
    if self.admin
      Committee.all
    else
      self.committees
    end
  end

  def is_committee_admin(committee = nil)
    committee_members.each do |cm|
      if cm.committee == committee or committee == nil
        if cm.admin
          return true
        end
      end
    end
    false
  end

  def is_committee_editor(committee = nil)
    committee_members.each do |cm|
      if cm.committee == committee or committee == nil
        if cm.editor
          return true
        end
      end
    end
    false
  end

  def is_in_committee(committee)
    committee_members.each do |cm|
      if cm.committee == committee
        return true
      end
    end
    false
  end

  def voting_member(committee)
    committee_members.find_by(committee: committee).try(:voting)
  end

  def voting_text(committee)
    voting_member(committee) ? "Voting Member" : "Non-Voting Member"
  end

  def to_s
    name.presence || short_email
  end

  def short_email
    email.truncate(9)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end
end
