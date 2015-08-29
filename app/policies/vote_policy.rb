class VotePolicy < ApplicationPolicy

  def show?
    admin_or_committee_admin?
  end

  def create?
    # policy(record.proposal).vote?
    record.proposal.status == 'Voting' && user.voting_member(record.proposal.committee)
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  private

  def admin_or_committee_admin?
    admin? || committee_admin?(record.proposal.committee)
  end
end
