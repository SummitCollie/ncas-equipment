# Historical record of a check-out action
class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_and_belongs_to_many :assets

  after_save :update_assets

  validates :assets, presence: true
  validate :assets_can_be_checked_out, on: :create

  private

  def update_assets
    assets.transaction do
      assets.each do |asset|
        asset.update!(user: user, location: location)
      end
    end
  end

  def assets_can_be_checked_out
    valid_ids = Asset.can_check_out.pluck(:id)
    assets.each do |asset|
      errors.add(
        :asset,
        <<~HEREDOC
          "#{asset.name}" is already checked out by
          #{asset&.user&.display_name || asset&.user&.email || "someone"}
        HEREDOC
      ) unless valid_ids.include?(asset.id)
    end
  end
end
