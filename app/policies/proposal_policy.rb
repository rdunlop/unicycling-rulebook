class ProposalPolicy < ApplicationPolicy

  def index?
    true
  end

  def passed?
    true
  end

  def show?
    return true if record.status != 'Submitted'
    return true if admin?
    return false if user.nil?

    if record.status == 'Submitted'
      user.is_committee_admin(record.committee) || record.try(:owner) == user
    else
      user.is_in_committee(record.committee)
    end
  end

  def destroy?
    admin?
  end

  def update?
    admin? || user && user.is_committee_admin(record.committee)
  end

  # Only voting members can vote
  def vote?
    record.status == 'Voting' && user.voting_member(record.committee)
  end

  def view_votes?
    admin? || committee_admin?(record.committee)
  end
end
