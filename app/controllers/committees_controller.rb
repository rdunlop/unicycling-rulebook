class CommitteesController < ApplicationController
  before_filter :authenticate_user!, :except => [:membership, :show]
  load_and_authorize_resource

  # GET /committees
  # GET /committees.json
  def index
    @committees = Committee.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @committees }
    end
  end

  def show
    @committee = Committee.find(params[:id])
    @proposals = []
    @committee.proposals.each do |p|
      if can? :read, p
        @proposals += [p]
      end
    end
    if user_signed_in?
      @user_votes = current_user.votes
    else
      @user_votes = []
    end
  end

  # GET /committees/new
  # GET /committees/new.json
  def new
    @committee = Committee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @committee }
    end
  end

  # GET /committees/1/edit
  def edit
    @committee = Committee.find(params[:id])
  end

  # POST /committees
  # POST /committees.json
  def create
    respond_to do |format|
      if @committee.save
        format.html { redirect_to committees_path, notice: 'Committee was successfully created.' }
        format.json { render json: @committee, status: :created, location: committees_path }
      else
        format.html { render action: "new" }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /committees/1
  # PUT /committees/1.json
  def update
    @committee = Committee.find(params[:id])

    respond_to do |format|
      if @committee.update_attributes(committee_params)
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
    @committee = Committee.find(params[:id])
    @committee.destroy

    respond_to do |format|
      format.html { redirect_to committees_url }
      format.json { head :no_content }
    end
  end

  def membership
    @committees = Committee.includes(:committee_members).all
    @users = User.all
  end

  private

  def committee_params
    params.require(:committee).permit(:name, :preliminary)
  end
end
