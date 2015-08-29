class CommitteePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def membership?
    true
  end

  def update?
    admin?
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end
end
