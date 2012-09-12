class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
        can [:read], Proposal do |proposal|
            proposal.status != 'Submitted'
        end
        can :passed, Proposal
        return # no permissions
    end

    #??? user ||= User.new # default user if not signed in

    # SUPER ADMIN can do anything
    if user.admin
        can :manage, Committee
        can :manage, CommitteeMember

        can :manage, Proposal
            #includes :set_pre_voting
            # and :set_review, :set_voting, :administer
        # remove 'vote' from the 'all' set 
        # (even administrators can't vote if not a voting member with proposal in 'voting' status)
        cannot :vote, Proposal

        can :manage, Revision
        can :manage, Vote
        can :manage, Comment
        can :manage, User
    else
        can :read, Committee
        can :membership, Committee
        can :create, Comment
        can :create, Vote

        can :create, Proposal
        can :read, User

        can [:read], Proposal do |proposal|
            if proposal.status == 'Submitted'
                user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user
            else
                user.is_in_committee(proposal.committee)
            end
        end

        can :update, Proposal do |proposal|
            user.is_committee_admin(proposal.committee)
        end
        can :read, Vote do |vote|
            user.is_committee_admin(vote.proposal.committee)
        end

        # Owner-specific
        # Committee-admin-specific
        can [:set_review, :set_voting], Proposal do |proposal|
            user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user
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
