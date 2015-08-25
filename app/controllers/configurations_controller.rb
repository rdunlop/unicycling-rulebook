class ConfigurationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :rulebook
  before_action :load_current_rulebook
  before_action { add_breadcrumb "App Configuration" }

  # GET /configurations/1
  # GET /configurations/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rulebook }
    end
  end

  # GET /configurations/1/edit
  def edit
  end

  # PUT /configurations/1
  # PUT /configurations/1.json
  def update

    respond_to do |format|
      if @rulebook.update_attributes(rulebook_params)
        format.html { redirect_to configuration_path(@rulebook), notice: 'Rulebook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rulebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configurations/1
  def destroy
    Apartment::Tenant.drop(@rulebook.subdomain)
    @rulebook.destroy

    respond_to do |format|
      format.html { redirect_to welcome_index_all_path }
      format.json { head :no_content }
    end
  end

  private

  def rulebook_params
    params.require(:rulebook).permit(:rulebook_name, :front_page, :faq, :copyright, :proposals_allowed)
  end

  def load_current_rulebook
    @rulebook = Rulebook.find(params[:id])
    raise CanCan::AccessDenied.new("Only allowed to modify current rulebook config") if @rulebook != @config
  end

end
