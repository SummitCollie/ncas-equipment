# Historical record of a check-in action
class Checkin < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_and_belongs_to_many :assets

  after_save :update_assets

  validates :assets, presence: true

  private

  def update_assets
    assets.transaction do
      assets.each do |asset|
        asset.update!(user: nil, location: location)
      end
    end
  end
end
