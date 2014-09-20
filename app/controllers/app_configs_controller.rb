class AppConfigsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /app_configs
  # GET /app_configs.json
  def index
    @app_configs = AppConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @app_configs }
    end
  end

  # GET /app_configs/1
  # GET /app_configs/1.json
  def show
    @app_config = AppConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app_config }
    end
  end

  # GET /app_configs/new
  # GET /app_configs/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app_config }
    end
  end

  # GET /app_configs/1/edit
  def edit
    @app_config = AppConfig.find(params[:id])
  end

  # POST /app_configs
  # POST /app_configs.json
  def create
    respond_to do |format|
      if @app_config.save
        format.html { redirect_to @app_config, notice: 'App config was successfully created.' }
        format.json { render json: @app_config, status: :created, location: @app_config }
      else
        format.html { render action: "new" }
        format.json { render json: @app_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /app_configs/1
  # PUT /app_configs/1.json
  def update
    @app_config = AppConfig.find(params[:id])

    respond_to do |format|
      if @app_config.update_attributes(app_config_params)
        format.html { redirect_to @app_config, notice: 'App config was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @app_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_configs/1
  # DELETE /app_configs/1.json
  def destroy
    @app_config = AppConfig.find(params[:id])
    @app_config.destroy

    respond_to do |format|
      format.html { redirect_to app_configs_url }
      format.json { head :no_content }
    end
  end

  private

  def app_config_params
    params.require(:app_config).permit(:rulebook_name, :front_page, :faq, :copyright)
  end
end
