class Checkout < ApplicationRecord
  belongs_to :user
  belongs_to :asset
  belongs_to :order
  belongs_to :location

  validates :user, presence: true
  validates :asset, presense: true
  validates :location, presence: true
end
