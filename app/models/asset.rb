class Asset < ApplicationRecord
  scope :checked_out, -> { joins(:checkouts).where('checkouts.returned_at IS NULL') }

  acts_as_ordered_taggable

  has_many :checkouts
  has_many :orders, through: :checkouts

  validates :name, presence: true
  validates :checkout_scan_required, inclusion: [true, false]

  before_save :ensure_tag_colors_present

  def available_to_check_out?
    last_checkout = checkouts.last
    last_checkout.nil? || last_checkout.returned_at.present?
  end

  private

  def ensure_tag_colors_present
    uncolored_tag_ids = tags.filter { |tag| tag.color.blank? }.pluck(:id)
    return if uncolored_tag_ids.empty?

    ActsAsTaggableOn::Tag.transaction do
      uncolored_tag_ids.each do |tag_id|
        tag = ActsAsTaggableOn::Tag.find(tag_id)
        tag.update(color: "##{SecureRandom.hex(3)}")
      end
    end
  end
end
