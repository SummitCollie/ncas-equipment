class Asset < ApplicationRecord
  scope :checked_out, -> { joins(:checkouts).where('checkouts.returned_at IS NULL') }

  acts_as_ordered_taggable

  has_many :checkouts
  has_many :orders, through: :checkouts

  validates :name, presence: true
  validates :checkout_scan_required, inclusion: [true, false]

  after_commit :ensure_tag_colors_present, on: [:create, :update]

  def available_to_check_out?
    last_checkout = checkouts.last
    last_checkout.nil? || last_checkout.returned_at.present?
  end

  private

  def ensure_tag_colors_present
    uncolored_tags = tags.filter { |tag| tag.color.blank? }
    return if uncolored_tags.blank?

    ActsAsTaggableOn::Tag.transaction do
      uncolored_tags.each do |tag|
        tag.update(color: "##{SecureRandom.hex(3)}")
      end
    end
  end
end
