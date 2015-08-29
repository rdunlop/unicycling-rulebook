class RulebookPolicy < ApplicationPolicy

  def show?
    admin?
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
