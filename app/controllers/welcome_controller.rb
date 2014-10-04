class WelcomeController < ApplicationController
  skip_authorization_check
  layout "global", only: [:index_all]

  def index_all
    @rulebooks = Rulebook.all
  end

  def index
    @committees = Committee.ordered.all
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

  def message
    authorize! :send, Message
    @committees = Committee.all
    @from = current_user.name
    @from_email = current_user.email
  end

  def send_message
    authorize! :send, Message

    @committee_numbers = params[:committees]
    @committees = []
    if not @committee_numbers.nil?
      @committee_numbers.each do |cn|
        @committees << Committee.find(cn)
      end
    end
    @subject = params[:subject]
    @body = params[:body]
    @reply_email = current_user.email

    if @committees.empty?
      flash[:alert] = "No Target Selected"
    else
      if UserMailer.mass_email(@committees, @subject, @body, @reply_email).deliver
        flash[:notice] = "Message Successfully Sent"
      else
        flash[:alert] = "Message Send Error"
      end
    end

    redirect_to welcome_message_path
  end
end
