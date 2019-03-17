class DiscussionPolicy < ApplicationPolicy
  def show?
    return true unless record.committee.private?
    return false unless user

    user.is_in_committee(record.committee)
  end

  def close?
    return false unless record.active?

    record.owner == user || admin? || committee_admin?(record.committee)
  end

  def create?
    user.is_in_committee(record.committee)
  end
end
