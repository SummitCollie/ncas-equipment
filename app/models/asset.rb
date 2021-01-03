class Asset < ApplicationRecord
  has_and_belongs_to_many :checkouts
  has_and_belongs_to_many :checkins
  has_one :current_location
end
