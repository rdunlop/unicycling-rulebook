class ProposalPolicy < ApplicationPolicy

  # Only voting members can vote
  def vote?
    record.status == 'Voting' && user.voting_member(record.committee)
  end

  def view_votes?
    admin? || committee_admin?(record.committee)
  end
end
