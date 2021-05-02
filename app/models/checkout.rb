# Historical record of a check-out action
class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_and_belongs_to_many :assets

  after_save :update_assets

  validates :user, presence: true
  validates :location, presence: true
  validates :assets, presence: true
  validate :asset_not_checked_out, on: :create

  private

  def update_assets
    assets.transaction do
      assets.each do |asset|
        asset.update!(user: user, location: location)
      end
    end
  end

  def asset_not_checked_out
    assets.each do |asset|
      unless asset.available_to_check_out?
        errors.add(:asset, "\"#{asset.name}\" has already been checked out")
      end
    end
  end
end
