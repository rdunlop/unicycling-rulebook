# == Schema Information
#
# Table name: proposals
#
#  id                          :integer          not null, primary key
#  committee_id                :integer
#  status                      :string(255)
#  submit_date                 :date
#  review_start_date           :date
#  review_end_date             :date
#  vote_start_date             :date
#  vote_end_date               :date
#  tabled_date                 :date
#  transition_straight_to_vote :boolean
#  owner_id                    :integer
#  title                       :text
#  created_at                  :datetime
#  updated_at                  :datetime
#  mail_messageid              :string(255)
#

class Proposal < ActiveRecord::Base
    belongs_to :owner, :class_name => "User"
    belongs_to :committee
    has_many :votes, -> { order("created_at ASC") }
    has_many :comments, through: :discussion
    has_one :discussion
    has_many :revisions, -> { order("id DESC") }

    validates :owner, :presence => true
    validates :title, :presence => true
    validates :committee, :presence => true
    validates :status, :inclusion => { :in => [ 'Submitted', 'Review', 'Pre-Voting', 'Voting', 'Tabled', 'Passed', 'Failed' ] }

    attr_accessible :title, :committee_id, :status, :review_start_date, :review_end_date, :vote_start_date, :vote_end_date, :tabled_date

    # This is the auto-updated function CLASS METHOD
    def self.update_states
        Proposal.all.each do |proposal|
            if proposal.status == 'Review' and proposal.review_end_date < Date.today
                proposal.status = 'Pre-Voting'
                puts "Changing Proposal #{proposal.title} from Review to Pre-Voting"
                proposal.save
                UserMailer.proposal_finished_review(proposal).deliver
            elsif proposal.status == 'Voting' and (proposal.vote_end_date < Date.today or proposal.all_voting_members_voted)
                if proposal.have_voting_quorum and proposal.at_least_two_thirds_agree
                    proposal.status = 'Passed'
                else
                    proposal.status = 'Failed'
                end
                puts "Changing Proposal #{proposal.title} from Voting to #{proposal.status}"
                proposal.save
                UserMailer.proposal_voting_result(proposal, proposal.status == 'Passed').deliver
            end
        end
    end

    def at_least_two_thirds_agree
        votes_which_count = self.agree_votes + self.disagree_votes
        (self.agree_votes / votes_which_count.to_f) >= (2 / 3.0)
    end

    def have_voting_quorum
        if number_of_voting_members == 0
            return false
        end

        if (self.votes.count / number_of_voting_members.to_f) >= 0.50
            true
        else
            false
        end
    end

    def number_of_voting_members
        x = self.committee.committee_members.select {|cm| cm.voting }
        x.count
    end

public
    def all_voting_members_voted
        self.number_of_voting_members == self.votes.count
    end

    def latest_revision
        if self.revisions.empty?
            nil
        else
            self.revisions.first
        end
    end

    def latest_revision_number
        if self.latest_revision.nil?
            0
        else
            self.latest_revision.num
        end
    end

    def background
        self.latest_revision.background
    end

    def body
        self.latest_revision.body
    end

    def references
        self.latest_revision.references
    end

private
    def count_votes(type)
        count = 0
        votes.each do |v|
            if v.vote == type
                count += 1
            end
        end
        count
    end

public
    def agree_votes
        count_votes('agree')
    end
    def disagree_votes
        count_votes('disagree')
    end
    def abstain_votes
        count_votes('abstain')
    end

    def status_summary
        if self.status == 'Submitted'
            ""
        elsif self.status == 'Review'
            "Ends " + self.review_end_date.to_date.to_s(:long)
        elsif status == 'Pre-Voting'
            "Ended " + self.review_end_date.to_date.to_s(:long)
        elsif status == 'Voting'
            "Ends " + self.vote_end_date.to_date.to_s(:long)
        elsif status == 'Tabled'
            "" + self.tabled_date.to_date.to_s(:long)
        elsif status == 'Passed'
            "" + self.vote_end_date.to_date.to_s(:long)
        elsif status == 'Failed'
            "" + self.vote_end_date.to_date.to_s(:long)
        end
    end

    def vote_detail(user_votes)
        user_votes.each do |v|
            if v.proposal == self
                return v.vote
            end
        end
        ""
    end

    def status_string
        if self.status == 'Submitted'
            "Submitted"
        elsif self.status == 'Review'
            "Review from " + self.review_start_date.to_date.to_s(:long) + " to " + self.review_end_date.to_date.to_s(:long)
        elsif status == 'Pre-Voting'
            "Pre-Voting (Reviewed from " + self.review_start_date.to_date.to_s(:long) + " to " + self.review_end_date.to_date.to_s(:long) + ")"
        elsif status == 'Voting'
            "Voting from " + self.vote_start_date.to_date.to_s(:long) + " to " + self.vote_end_date.to_date.to_s(:long)
        elsif status == 'Tabled'
            "Set-Aside (Reviewed from " + self.review_start_date.to_date.to_s(:long) + " to " + self.review_end_date.to_date.to_s(:long) + ")"
        elsif status == 'Passed'
            "Passed on " + self.vote_end_date.to_date.to_s(:long)
        elsif status == 'Failed'
            "Failed on " + self.vote_end_date.to_date.to_s(:long)
        end
    end

    def last_update_time
      last_time = self.latest_revision.created_at
      if self.discussion
        if last_time < discussion.last_update_time
            last_time = discussion.last_update_time
        end
      end
      last_time
    end

    def to_s
        title
    end
end
