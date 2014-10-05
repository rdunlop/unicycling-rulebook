class ConfigurationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :rulebook

  # GET /configurations/1
  # GET /configurations/1.json
  def show
    @rulebook = Rulebook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rulebook }
    end
  end

  # GET /configurations/1/edit
  def edit
    @rulebook = Rulebook.find(params[:id])
  end

  # PUT /configurations/1
  # PUT /configurations/1.json
  def update
    @rulebook = Rulebook.find(params[:id])

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
  # DELETE /configurations/1.json
  def destroy
    @rulebook = Rulebook.find(params[:id])
    @rulebook.destroy

    respond_to do |format|
      format.html { redirect_to configurations_url }
      format.json { head :no_content }
    end
  end

  private

  def rulebook_params
    params.require(:rulebook).permit(:rulebook_name, :front_page, :faq, :copyright, :subdomain)
  end
end
