class CommitteePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def membership?
    true
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

  def create_proposal?
    if proposals_allowed? || user.is_committee_admin(record)
      user.voting_member(record)
    end
  end

  def create_discussion?
    user.is_in_committee(record)
  end

  def read_usernames?
    user.is_in_committee(record)
  end

  private

  def proposals_allowed?
    Rulebook.current_rulebook.proposals_allowed?
  end
end
