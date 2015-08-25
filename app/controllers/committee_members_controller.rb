class CommitteeMembersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :committee
  before_action :set_committee_breadcrumb
  load_and_authorize_resource :committee_member, through: :committee

  # GET /committee_members
  # GET /committee_members.json
  def index
    add_breadcrumb "Committee Members"
    @committee_members = @committee.committee_members

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @committee_members }
    end
  end

  # GET /committee_members/new
  # GET /committee_members/new.json
  def new
    add_breadcrumb "New Member"
    load_committee_new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@committee, @committee_member] }
    end
  end

  # GET /committee_members/1/edit
  def edit
    add_breadcrumb "Edit Member"
    @committee_member = CommitteeMember.find(params[:id])
    @users = User.all
  end

  # POST /committee_members
  # POST /committee_members.json
  def create
    @success = true
    if params[:committee_member][:user_id]
      params[:committee_member][:user_id].each do |user|
        next if user.blank?
        @committee_member = CommitteeMember.new(
          user_id: user,
          voting: params[:committee_member][:voting],
          admin: params[:committee_member][:admin],
          editor: params[:committee_member][:editor])
        @committee_member.committee = @committee
        unless @committee_member.save
          @success = false
        end
      end
    else
      @success = false
    end

    respond_to do |format|
      if @success
        format.html { redirect_to committee_committee_members_path(@committee), notice: 'Committee member was successfully created.' }
        format.json { render json: @committee, status: :created, location: committee_committee_members_path(@committee) }
      else
        load_committee_new
        format.html { render action: "new" }
        format.json { render json: @committee_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /committee_members/1
  # PUT /committee_members/1.json
  def update
    @committee_member = CommitteeMember.find(params[:id])

    respond_to do |format|
      if @committee_member.update_attributes(committee_member_params)
        format.html { redirect_to committee_committee_members_path(@committee), notice: 'Committee member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @committee_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /committee_members/1
  # DELETE /committee_members/1.json
  def destroy
    @committee_member = CommitteeMember.find(params[:id])
    @committee_member.destroy

    respond_to do |format|
      format.html { redirect_to committee_committee_members_url(@committee) }
      format.json { head :no_content }
    end
  end

  private

  def committee_member_params
    params.require(:committee_member).permit(:user_id, :committee_id, :voting, :admin, :editor)
  end

  def load_committee_new
    @committee_member = CommitteeMember.new
    @users = User.all
    @users -= @committee.committee_members.map{|member| member.user}
  end

end
