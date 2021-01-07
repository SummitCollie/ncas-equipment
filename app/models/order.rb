class Order < ApplicationRecord
  has_many :checkouts
  has_many :assets, through: :checkouts
  belongs_to :user

  validates :user, presence: true
  validates :has_assets

  private

  def has_assets
    if assets.empty?
      errors.add(:base, "There are no categories")
    end
  end
end
