class Location < ApplicationRecord
  belongs_to :event
  has_many :assets
  has_many :checkouts
  has_many :checkins

  validates :event, presence: true
end
