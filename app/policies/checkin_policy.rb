class CheckinPolicy < ApplicationPolicy
  def update?
    false
  end

  def permitted_attributes
    if user.admin?
      return [:assets, :user, :location, :returned_at]
    end

    [:assets, :location, :returned_at]
  end
end
