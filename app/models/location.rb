class Location < ApplicationRecord
  belongs_to :event
  has_many :checkouts
end
