class CommitteeMemberPolicy < ApplicationPolicy
  def index?
    admin? || committee_admin?
  end

  def show?
    admin? || committee_admin?(record.committee)
  end

  def update?
    admin? || committee_admin?(record.committee)
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end
end
