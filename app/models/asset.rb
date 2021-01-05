class Asset < ApplicationRecord
  scope :checked_out, -> { where('') } # TODO

  has_many :checkouts
  has_many :orders, through: :checkouts
end
