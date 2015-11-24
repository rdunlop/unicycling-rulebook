class BulkUsersPolicy < ApplicationPolicy
  def create?
    admin?
  end
end
