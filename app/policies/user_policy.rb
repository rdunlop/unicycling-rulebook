class UserPolicy < ApplicationPolicy
  def edit?
    admin?
  end

  def update?
    admin?
  end
end
