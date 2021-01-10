class Asset < ApplicationRecord
  scope :checked_out, -> { joins(:checkouts).where('checkouts.returned_at IS NULL') }

  acts_as_taggable_on :tags

  has_many :checkouts
  has_many :orders, through: :checkouts

  validates :name, presence: true
  validates :checkout_scan_required, inclusion: [true, false]
end
