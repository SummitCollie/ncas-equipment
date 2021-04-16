class Checkout < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :asset
  belongs_to :location

  validates :user, presence: true
  validates :asset, presence: true
  validates :location, presence: true
  validate :asset_not_checked_out, on: :create

  after_initialize :copy_attrs_from_order, if: :new_record?

  private

  def asset_not_checked_out
    asset = Asset.find(asset_id)
    unless asset.available_to_check_out?
      errors.add(:asset, "\"#{asset.name}\" has already been checked out")
    end
  end

  def copy_attrs_from_order
    return unless order
    self.user = order.user
    self.location = order.location
  end
end
