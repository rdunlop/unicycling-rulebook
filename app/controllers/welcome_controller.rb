class WelcomeController < ApplicationController
  skip_authorization_check

  def index
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
    # else
    # @majority_text = $majority *100 + "%"
  end
end
