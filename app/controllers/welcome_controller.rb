class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    @proposals = []
    Proposal.all.each do |p|
      if can? :read, p
        @proposals += [p]
      end
    end
    @committees = @proposals.map {|p| p.committee}.uniq{|c| c.id}
    # sort the committees so that non-preliminary come first
    @committees = @committees.sort {|a,b| a.preliminary == b.preliminary ? 0 : a.preliminary ? 1 : -1 }
    if user_signed_in?
        @user_votes = current_user.votes
    else
        @user_votes = []
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
