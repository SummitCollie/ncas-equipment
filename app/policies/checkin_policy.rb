class CheckinPolicy < ApplicationPolicy
  def update?
    false
  end

  def permitted_attributes
    if user.admin?
      return [:user, :location, :returned_at]
    end

    [:location, :returned_at]
  end
end
