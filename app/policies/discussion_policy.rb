class DiscussionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def close?
    return false unless record.active?

    record.owner == user || admin? || committee_admin?(record.committee)
  end

  def create?
    user.is_in_committee(record.committee)
  end
end
