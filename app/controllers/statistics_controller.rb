class StatisticsController < ApplicationController
  before_action :authenticate_user!

  # GET /statistics
  def index
    authorize :statistics
    @users = User.includes(:votes, :discussion_comments).all
  end
end
