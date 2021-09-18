# Historical record of a check-in action
class Checkin < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_and_belongs_to_many :assets

  after_save :update_assets

  validates :assets, presence: true
  validate :assets_can_be_checked_in, on: :create

  private

  def update_assets
    assets.transaction do
      assets.each do |asset|
        asset.update!(user: nil, location: location)
      end
    end
  end

  def assets_can_be_checked_in
    valid_ids = Asset.can_check_in.pluck(:id)
    assets.each do |asset|
      errors.add(:asset, "\"#{asset.name}\" isn't checked out") unless valid_ids.include?(asset.id)
    end
  end
end
