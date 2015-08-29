class Ability
  include CanCan::Ability
  # very important reference: https://github.com/ryanb/cancan/wiki/Nested-Resources

  def proposals_allowed?
    Rulebook.current_rulebook.proposals_allowed?
  end

  def initialize(user)

    user ||= User.new # default user if not signed in

    # PUBLIC can:
    # SUPER ADMIN can do anything
    if user.admin
      can :manage, User
      can :view, :all_rulebooks_list
    end

    # allows editors and admins to see the e-mail address of the proposal owner (for out-of-band communication)
    can :read_email, Proposal do |proposal|
      user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user or user.is_committee_editor(proposal.committee)
    end
  end
end
