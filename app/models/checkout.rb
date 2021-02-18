class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :asset
  belongs_to :order
  belongs_to :location

  validates :user, presence: true
  validates :asset, presence: true
  validates :location, presence: true
  validate :asset_not_checked_out

  def self.policy_class
    OrderPolicy
  end

  # Normal checkout process involves creating one Checkout for each Asset checked out
  def self.batch_create(asset_ids, user_id, location_id)
    transaction do
      asset_ids.map do |asset_id|
        raise ActiveRecord::Rollback unless Checkout.create!(
          asset: asset_id,
          user: user_id,
          location: location_id,
        )
      end
    end
  end

  private

  def asset_not_checked_out
    Asset.find(asset.id).available_to_check_out?
  end
end
