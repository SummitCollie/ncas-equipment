class Checkout < ApplicationRecord
  has_and_belongs_to_many :assets
  belongs_to :location
end
