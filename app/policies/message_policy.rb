class MessagePolicy < ApplicationPolicy

  def create?
    admin? || committee_admin?
  end
end
