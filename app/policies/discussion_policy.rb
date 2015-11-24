class DiscussionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def close?
    record.active? && (record.owner == user || admin?)
  end

  def create?
    user.is_in_committee(record.committee)
  end
end
