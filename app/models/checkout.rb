class Checkout < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :asset
  belongs_to :location

  validates :user, presence: true
  validates :asset, presence: true
  validates :location, presence: true
  validate :asset_not_checked_out, on: :create

  private

  def asset_not_checked_out
    asset = Asset.find(asset_id)
    unless asset.available_to_check_out?
      errors.add(:asset, "\"#{asset.name}\" has already been checked out")
    end
  end
end
