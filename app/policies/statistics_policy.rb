class StatisticsPolicy < ApplicationPolicy
  def index?
    admin?
  end
end
