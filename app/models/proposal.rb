class Proposal < ActiveRecord::Base
    belongs_to :owner, :class_name => "User"
    belongs_to :committee
    has_many :votes
    has_many :comments
    has_many :revisions, :order => "id DESC"

    validates :owner, :presence => true
    validates :title, :presence => true
    validates :committee, :presence => true
    validates :status, :inclusion => { :in => [ 'Submitted', 'Review', 'Pre-Voting', 'Voting', 'Tabled', 'Passed', 'Failed' ] }

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

    def count_votes(type)
        count = 0
        votes.each do |v|
            if v.vote == type
                count += 1
            end
        end
        count
    end

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

    def vote_detail(user)
        votes.each do |v|
            if v.user == user
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

    def to_s
        title
    end
end
