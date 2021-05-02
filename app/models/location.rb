class Location < ApplicationRecord
  belongs_to :event
  has_many :assets
  has_many :checkouts
  has_many :checkins

  validates :name, presence: true
end
