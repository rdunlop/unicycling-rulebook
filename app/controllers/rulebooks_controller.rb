class RulebooksController < ApplicationController
  skip_authorization_check only: [:new, :create, :index, :show]
  load_resource only: [:new, :create, :index, :show]
  layout "global"

  # GET /rulebooks
  # GET /rulebooks.json
  def index
    @rulebooks = Rulebook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rulebooks }
    end
  end

  # GET /rulebooks/1
  # GET /rulebooks/1.json
  def show
    @rulebook = Rulebook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rulebook }
    end
  end

  # GET /rulebooks/new
  # GET /rulebooks/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rulebook }
    end
  end

  # POST /rulebooks
  # POST /rulebooks.json
  def create
    raise CanCan::AccessDenied.new("Incorrect Access code") unless params[:access_code] == Rails.application.secrets.rulebook_creation_access_code
    raise Exception.new("Unable to name a schema 'public'") if @rulebook.subdomain == "public"

    respond_to do |format|
      if @rulebook.save
        Apartment::Tenant.create(@rulebook.subdomain)
        format.html { redirect_to @rulebook, notice: 'Rulebook was successfully created.' }
        format.json { render json: @rulebook, status: :created, location: @rulebook }
      else
        format.html { render action: "new" }
        format.json { render json: @rulebook.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def rulebook_params
    params.require(:rulebook).permit(:rulebook_name, :front_page, :faq, :copyright, :subdomain, :admin_upgrade_code)
  end
end
