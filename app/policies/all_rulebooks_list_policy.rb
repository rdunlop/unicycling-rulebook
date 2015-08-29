class AllRulebooksListPolicy < ApplicationPolicy

  def show?
    admin?
  end
end
