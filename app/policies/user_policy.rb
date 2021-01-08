class UserPolicy < ApplicationPolicy
  attr_reader :user, :the_user

  def initialize(user, the_user)
    @user = user
    @the_user = the_user
  end

  def permitted_attributes
    attrs = []
    if user.admin?
      attrs += [:email, :admin, :orders, :checkouts]
      attrs.push(:display_name) if user.id == the_user.id
    elsif user.id == the_user.id
      attrs += [:email, :orders, :checkouts, :display_name]
    end
    attrs
  end
end
