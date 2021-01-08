# CheckoutPolicy, Administrate forces this to be named OrderPolicy...
class OrderPolicy < ApplicationPolicy
  attr_reader :user, :checkout

  def initialize(user, checkout)
    @user = user
    @checkout = checkout
  end
end
