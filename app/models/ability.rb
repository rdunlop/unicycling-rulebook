class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
        return # no permissions
    end

    #??? user ||= User.new # default user if not signed in

    if user.admin
        can :manage, Committee
        can :manage, CommitteeMember

        can [:read, :update, :create, :destroy], Proposal
        can :set_voting, Proposal
        can :set_review, Proposal
        #admin-only:
        can :set_pre_voting, Proposal

        can :manage, Revision

        can :manage, Vote
        can :manage, Comment
    else
        can :read, Committee
        can :manage, Comment
        can :create, Vote
        can [:read, :update, :create, :destroy], Proposal
        can :set_voting, Proposal do |proposal|
            proposal.try(:owner) == user
        end
        can :set_review, Proposal do |proposal|
            proposal.try(:owner) == user
        end
        can :create, Revision do |revision|
            revision.proposal.owner == user
        end
    end

    can :vote, Proposal do |proposal|
        proposal.status == 'Voting' and user.voting_member(proposal.committee)
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
