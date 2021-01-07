class Location < ApplicationRecord
  belongs_to :event
  has_many :checkouts

  validates :event, presence: true
end
