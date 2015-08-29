class RulebooksController < ApplicationController
  skip_authorization_check only: [:new, :create, :index, :show]
  before_action :load_rulebook, only: [:create, :show]
  layout "global"

  # GET /rulebooks
  def index
    @rulebooks = Rulebook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rulebooks }
    end
  end

  # GET /rulebooks/1
  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /rulebooks/new
  def new
    @rulebook = Rulebook.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /rulebooks
  def create
    errors = []
    errors << "Incorrect Access code" unless params[:access_code] == Rails.application.secrets.rulebook_creation_access_code
    errors << "Unable to name a schema 'public'" if @rulebook.subdomain == "public"

    respond_to do |format|
      if errors.empty? && @rulebook.save
        Apartment::Tenant.create(@rulebook.subdomain)
        format.html { redirect_to @rulebook, notice: 'Rulebook was successfully created.' }
      else
        flash.now[:alert] = errors.join(", ")
        format.html { render action: "new" }
      end
    end
  end

  private

  def rulebook_params
    params.require(:rulebook).permit(:rulebook_name, :front_page, :faq, :copyright, :subdomain, :admin_upgrade_code, :proposals_allowed)
  end

  def load_rulebook
    @rulebook = Rulebook.find(params[:id])
  end

end
