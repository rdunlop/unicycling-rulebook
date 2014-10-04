class RulebooksController < ApplicationController
  skip_authorization_check only: [:new, :create, :index, :show]
  load_resource only: [:new, :create, :index, :show]
  layout "global"
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  load_and_authorize_resource only: [:edit, :update, :destroy]

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

  # GET /rulebooks/1/edit
  def edit
    @rulebook = Rulebook.find(params[:id])
  end

  # POST /rulebooks
  # POST /rulebooks.json
  def create
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

  # PUT /rulebooks/1
  # PUT /rulebooks/1.json
  def update
    @rulebook = Rulebook.find(params[:id])

    respond_to do |format|
      if @rulebook.update_attributes(rulebook_params)
        format.html { redirect_to @rulebook, notice: 'Rulebook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rulebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rulebooks/1
  # DELETE /rulebooks/1.json
  def destroy
    @rulebook = Rulebook.find(params[:id])
    @rulebook.destroy

    respond_to do |format|
      format.html { redirect_to rulebooks_url }
      format.json { head :no_content }
    end
  end

  private

  def rulebook_params
    params.require(:rulebook).permit(:rulebook_name, :front_page, :faq, :copyright, :subdomain)
  end
end
