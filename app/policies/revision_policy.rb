class RevisionPolicy < ApplicationPolicy

  def create?
    true
  end


  def show?
    return true if admin?
    return false if user.nil?

    return true if user.is_committee_admin(record.try(:proposal).try(:committee))
    return true if record.try(:proposal).try(:owner) == user
    return true if user.is_committee_editor(record.try(:proposal).try(:committee))
  end
end
