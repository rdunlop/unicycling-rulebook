class ConfigurationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :load_rulebook
  before_action :authorize_rulebook
  before_action :ensure_current_rulebook

  before_action { add_breadcrumb "App Configuration" }

  # GET /configurations/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /configurations/1/edit
  def edit
  end

  # PUT /configurations/1
  def update

    respond_to do |format|
      if @rulebook.update_attributes(rulebook_params)
        format.html { redirect_to configuration_path(@rulebook), notice: 'Rulebook was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /configurations/1
  def destroy
    Apartment::Tenant.drop(@rulebook.subdomain)
    @rulebook.destroy

    respond_to do |format|
      format.html { redirect_to welcome_index_all_path }
    end
  end

  private

  def rulebook_params
    params.require(:rulebook).permit(:rulebook_name, :front_page, :faq, :copyright, :proposals_allowed)
  end

  def ensure_current_rulebook
    raise Pundit::NotAuthorizedError.new("Only allowed to modify current rulebook config") if @rulebook != @config
  end

  def load_rulebook
    @rulebook = Rulebook.find(params[:id])
  end

  def authorize_rulebook
    authorize @rulebook
  end

end
