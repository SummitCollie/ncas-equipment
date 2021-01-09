class DashboardsController < ApplicationController
  def index
    authorize(current_user)
  end
end
