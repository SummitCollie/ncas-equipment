class CheckoutPolicy < ApplicationPolicy
  def update?
    false
  end

  def permitted_attributes
    if user.admin?
      return [:user, :location, :est_return]
    end

    [:location, :est_return]
  end
end
