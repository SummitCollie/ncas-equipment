class Asset < ApplicationRecord
  scope :checked_out, -> { joins(:checkouts).where('checkouts.returned_at IS NULL') }

  has_many :checkouts
  has_many :orders, through: :checkouts

  validates :name, presence: true
  validates :checkout_scan_required, inclusion: [true, false]
end
