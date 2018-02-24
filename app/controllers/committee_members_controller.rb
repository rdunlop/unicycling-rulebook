# == Schema Information
#
# Table name: committee_members
#
#  id           :integer          not null, primary key
#  committee_id :integer
#  user_id      :integer
#  voting       :boolean          default(TRUE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  admin        :boolean          default(FALSE), not null
#  editor       :boolean          default(FALSE), not null
#

class CommitteeMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_committee
  before_action :set_committee_breadcrumb
  before_action :load_committee_member, only: %i[edit update destroy]

  # GET /committee_members
  def index
    authorize CommitteeMember
    add_breadcrumb "Committee Members"
    @committee_members = @committee.committee_members

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /committee_members/new
  def new
    add_breadcrumb "New Member"
    load_committee_new
    authorize @committee_member

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /committee_members/1/edit
  def edit
    authorize @committee_member
    add_breadcrumb "Edit Member"
    @users = User.all
  end

  # POST /committee_members
  def create
    @success = true
    if params[:committee_member][:user_id]
      params[:committee_member][:user_id].each do |user|
        next if user.blank?
        @committee_member = CommitteeMember.new(
          user_id: user,
          voting: params[:committee_member][:voting],
          admin: params[:committee_member][:admin],
          editor: params[:committee_member][:editor]
        )
        @committee_member.committee = @committee
        authorize @committee_member
        unless @committee_member.save
          @success = false
        end
      end
    else
      authorize CommitteeMember

      @success = false
    end

    respond_to do |format|
      if @success
        format.html { redirect_to committee_committee_members_path(@committee), notice: 'Committee member was successfully created.' }
      else
        load_committee_new
        format.html { render action: "new" }
      end
    end
  end

  # PUT /committee_members/1
  def update
    authorize @committee_member

    respond_to do |format|
      if @committee_member.update_attributes(committee_member_params)
        format.html { redirect_to committee_committee_members_path(@committee), notice: 'Committee member was successfully updated.' }
      else
        @users = User.all
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /committee_members/1
  def destroy
    authorize @committee_member
    @committee_member.destroy

    respond_to do |format|
      format.html { redirect_to committee_committee_members_url(@committee) }
    end
  end

  private

  def committee_member_params
    params.require(:committee_member).permit(:user_id, :committee_id, :voting, :admin, :editor)
  end

  def load_committee
    @committee = Committee.find(params[:committee_id])
  end

  def load_committee_member
    @committee_member = @committee.committee_members.find(params[:id])
  end

  def load_committee_new
    @committee_member = CommitteeMember.new
    @committee_member.committee = @committee
    @users = User.all
    @users -= @committee.committee_members.map { |member| member.user }
  end
end
