class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user.admin
        @proposals = Proposal.all
    else
        # XXX proposals should be ordered by committee and status
        @proposals = []
        current_user.committees.each do |c|
            c.proposals.each do |p|
                if p.status != 'Submitted'
                    @proposals += [p]
                end
            end
        end
    end
  end

  def help
    @contactemail = "robin@dunlopweb.com"
    @contactname = "robin"
    @committeename = "the committee"
    @REVIEWTIME_TEXT = "10 days"
    @REVISIONTIME_TEXT = "3 days"
    @VOTETIME_TEXT = "7 days"
    # if majority == 2/3
    @majority_text = "2/3"
    @majority = true
    # else
    # @majority_text = $majority *100 + "%"
  end
end
