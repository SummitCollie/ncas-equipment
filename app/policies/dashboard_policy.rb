class DashboardPolicy < Struct.new(:user, :dashboard)
  attr_reader :user, :dashboard

  def initialize(user, dashboard)
    @user = user
    @dashboard = dashboard
  end

  def show
    user&.active?
  end
end
