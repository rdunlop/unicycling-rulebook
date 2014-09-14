class Ability
  include CanCan::Ability
  # very important reference: https://github.com/ryanb/cancan/wiki/Nested-Resources

  def initialize(user)

    user ||= User.new # default user if not signed in

    # PUBLIC can:
    can [:read], Proposal do |proposal|
      proposal.status != 'Submitted'
    end
    can [:read], Committee
    can :read, Discussion
    can :create, Discussion do |discussion|
      user.is_in_committee(discussion.committee)
    end

    can :passed, Proposal
    can :membership, Committee


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

      can :manage, Vote
      can :manage, Revision
      can :manage, Comment
      can :manage, User
      can :manage, AppConfig
      can :send, Message
    end

    can :send, Message if user.is_committee_admin(nil)

    can :read, Discussion

    # Can only create comments if I am in the committee
    can :create, Comment do |comment|
      user.is_in_committee(comment.discussion.committee)
    end

    # Only voting members can vote
    can :vote, Proposal do |proposal|
      proposal.status == 'Voting' and user.voting_member(proposal.committee)
    end
    can :create, Vote do |vote|
      vote.proposal.status == 'Voting' and user.voting_member(vote.proposal.committee)
    end

    # You must be in a committee in order to be able to create a Proposal
    can :create, Proposal if user.accessible_committees.count > 0

    # only allow people to see the usernames if they are in the committee
    can :read_usernames, Proposal do |proposal|
      user.is_in_committee(proposal.committee)
    end

    # allows editors and admins to see the e-mail address of the proposal owner (for out-of-band communication)
    can :read_email, Proposal do |proposal|
      user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user or user.is_committee_editor(proposal.committee)
    end

    can [:read], Proposal do |proposal|
      if proposal.status == 'Submitted'
        user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user
      else
        user.is_in_committee(proposal.committee)
      end
    end

    # Committee-Admin

    can :read, Committee

    if user.is_committee_admin(nil) || user.admin
      can :read, CommitteeMember do |committte_member|
        user.is_committee_admin(committee_member.committee)
      end
    end

    can :update, CommitteeMember do |committee_member|
      user.is_committee_admin(committee_member.committee)
    end

    can :update, Proposal do |proposal|
      user.is_committee_admin(proposal.committee)
    end

    can :read, Vote do |vote|
      user.is_committee_admin(vote.proposal.committee)
    end

    can [:set_review], Proposal do |proposal|
      # allow owner to change from Tabled back to Review.
      # Allow committee admin to change from ALL STATES to review
      ((proposal.status == 'Tabled') and (proposal.try(:owner) == user)) or user.is_committee_admin(proposal.committee)
    end

    can [:set_pre_voting], Proposal do |proposal|
      user.is_committee_admin(proposal.committee)
    end

    # Owner-specific
    # Committee-admin-specific

    can [:set_voting], Proposal do |proposal|
      user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user
    end
    # editors can revise and table
    can [:revise, :table], Proposal do |proposal|
      user.is_committee_admin(proposal.committee) or proposal.try(:owner) == user or user.is_committee_editor(proposal.committee)
    end

    can :create, Revision
    can :read, Revision do |revision|
      user.is_committee_admin(revision.try(:proposal).try(:committee)) or revision.try(:proposal).try(:owner) == user or user.is_committee_editor(revision.try(:proposal).try(:committee))
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
