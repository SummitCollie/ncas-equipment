class DashboardPolicy < Struct.new(:user, :dashboard)
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def show
    user&.active?
  end
end
