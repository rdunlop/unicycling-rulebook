# == Schema Information
#
# Table name: committees
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  preliminary :boolean          default(TRUE), not null
#

class CommitteesController < ApplicationController
  before_action :authenticate_user!, except: %i[membership show]
  before_action :load_committee, only: %i[show edit update destroy]
  before_action :set_committee_breadcrumb, only: %i[show edit update destroy]
  before_action :authorize_committee, only: %i[show edit update destroy]

  # GET /committees
  # GET /committees.json
  def index
    add_breadcrumb "Committees"
    @committees = Committee.all
    authorize Committee

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @committees }
    end
  end

  def show
    @proposals = []
    @committee.proposals.each do |p|
      if policy(p).show?
        @proposals += [p]
      end
    end
    @user_votes = if user_signed_in?
                    current_user.votes
                  else
                    []
                  end
  end

  # GET /committees/new
  # GET /committees/new.json
  def new
    add_breadcrumb "New Committee"
    @committee = Committee.new
    authorize @committee

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @committee }
    end
  end

  # GET /committees/1/edit
  def edit; end

  # POST /committees
  # POST /committees.json
  def create
    @committee = Committee.new(committee_params)
    authorize @committee
    respond_to do |format|
      if @committee.save
        format.html { redirect_to committees_path, notice: 'Committee was successfully created.' }
        format.json { render json: @committee, status: :created, location: committees_path }
      else
        add_breadcrumb "New Committee"
        format.html { render action: "new" }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /committees/1
  # PUT /committees/1.json
  def update
    respond_to do |format|
      if @committee.update(committee_params)
        format.html { redirect_to committees_path, notice: 'Committee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /committees/1
  # DELETE /committees/1.json
  def destroy
    @committee.destroy

    respond_to do |format|
      format.html { redirect_to committees_url }
      format.json { head :no_content }
    end
  end

  def membership
    add_breadcrumb "Committee Members"
    authorize Committee
    @committees = Committee.includes(:committee_members).all
    @users = User.all
  end

  private

  def committee_params
    params.require(:committee).permit(:name, :preliminary, :private)
  end

  def load_committee
    @committee = Committee.find(params[:id])
  end

  def authorize_committee
    authorize @committee
  end
end
