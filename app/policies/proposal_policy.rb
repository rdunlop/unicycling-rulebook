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
    return false unless user

    record.status == 'Voting' && user.voting_member(record.committee)
  end

  def read_email
    user.is_committee_admin(record.committee) or record.try(:owner) == user or user.is_committee_editor(record.committee)
  end


  def view_votes?
    admin? || committee_admin?(record.committee)
  end

  # State transitions
  def set_voting?
    return true if admin?

    user.is_committee_admin(record.committee) or record.try(:owner) == user
  end

  def set_review?
    return true if admin?
    # allow owner to change from Tabled back to Review.
    # Allow committee admin to change from ALL STATES to review
    return true if ((record.status == 'Tabled')  && (record.try(:owner) == user))
    return true if user.is_committee_admin(record.committee)
  end

  def set_pre_voting?
    return true if admin?

    user.is_committee_admin(record.committee)
  end

  # editors can revise and table
  def table?
    revise?
  end

  def revise?
    return true if admin?

    user.is_committee_admin(record.committee) || record.try(:owner) == user || user.is_committee_editor(record.committee)
  end

  def vote?
    record.status == 'Voting' && user.voting_member(record.committee)
  end

end
