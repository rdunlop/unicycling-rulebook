class CommitteeMembersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  before_filter :load_committee

  def load_committee
    @committee = Committee.find(params[:committee_id])
  end

  # GET /committee_members
  # GET /committee_members.json
  def index
    @committee_members = CommitteeMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @committee_members }
    end
  end

  # GET /committee_members/1
  # GET /committee_members/1.json
  def show
    @committee_member = CommitteeMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @committee_member }
    end
  end

  # GET /committee_members/new
  # GET /committee_members/new.json
  def new
    @committee_member = CommitteeMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@committee, @committee_member] }
    end
  end

  # GET /committee_members/1/edit
  def edit
    @committee_member = CommitteeMember.find(params[:id])
  end

  # POST /committee_members
  # POST /committee_members.json
  def create
    @committee_member = CommitteeMember.new(params[:committee_member])

    respond_to do |format|
      if @committee_member.save
        format.html { redirect_to [@committee, @committee_member], notice: 'Committee member was successfully created.' }
        format.json { render json: [@committee, @committee_member], status: :created, location: [@committee, @committee_member] }
      else
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
      if @committee_member.update_attributes(params[:committee_member])
        format.html { redirect_to [@committee, @committee_member], notice: 'Committee member was successfully updated.' }
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
end
