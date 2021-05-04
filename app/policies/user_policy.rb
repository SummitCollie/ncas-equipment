class UserPolicy < ApplicationPolicy
  attr_reader :user, :the_user

  def initialize(user, the_user)
    @user = user
    @the_user = the_user
  end

  def permitted_attributes
    attrs = []
    if user.admin?
      attrs += [:email, :admin, :checkouts, :checkins]
      attrs.push(:display_name, :telegram) if user.id == the_user.id
    elsif user.id == the_user.id
      attrs += [:email, :checkouts, :checkins, :display_name, :telegram]
    end
    attrs
  end
end
