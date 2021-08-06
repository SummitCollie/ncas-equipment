class CheckoutPolicy < ApplicationPolicy
  def update?
    false
  end

  def permitted_attributes
    if user.admin?
      return [:assets, :user, :location, :est_return]
    end

    [:assets, :location, :est_return]
  end
end
