class OrderPolicy < ApplicationPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  def permitted_attributes_for_create
    if @user.admin?
      [:user_id, :location_id, :asset_ids]
    else
      [:location_id, :asset_ids]
    end
  end
end
