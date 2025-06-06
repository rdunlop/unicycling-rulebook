class WelcomeController < ApplicationController
  before_action :skip_authorization

  # Page where user can choose any of the rulebooks
  def index_all
    @rulebooks = Rulebook.all
    authorize :all_rulebooks_list, :show?
    add_breadcrumb "Choose a Rulebook"
    render layout: "global"
  end

  # Root path of the system
  def index
    @committees = Committee.ordered.all
  end

  # tells the user that we have moved the rulebook to its own server
  def new_location
    @rulebook = Rulebook.find_by!(subdomain: params[:rulebook_slug])
    render layout: "global"
  end

  def help
    add_breadcrumb "Faq"

    @contactemail = "robin@dunlopweb.com"
    @contactname = "robin"
    @committeename = "the committee"
    @REVIEWTIME_TEXT = "#{@config.review_days} days" # rubocop:disable Naming/VariableName
    @REVISIONTIME_TEXT = "3 days" # rubocop:disable Naming/VariableName
    @VOTETIME_TEXT = "#{@config.voting_days} days" # rubocop:disable Naming/VariableName
    # if majority == 2/3
    @majority_text = "2/3"
    @majority = true
    # else
    # @majority_text = $majority *100 + "%"
  end

  def message
    add_breadcrumb "Send E-mail"
    authorize(:message, :create?)
    @committees = Committee.all
    @from = current_user
    @from_email = current_user.email
  end

  def send_message
    authorize(:message, :create?)

    @committee_numbers = params[:committees] || []
    @subject = params[:subject]
    @body = params[:body]
    @reply_email = current_user.email

    if @committee_numbers.empty?
      flash[:alert] = "No Target Selected"
    else
      if UserMailer.mass_email(@committee_numbers, @subject, @body, @reply_email).deliver_later
        flash[:notice] = "Message Successfully Sent"
      else
        flash[:alert] = "Message Send Error"
      end
    end

    redirect_to welcome_message_path
  end
end
