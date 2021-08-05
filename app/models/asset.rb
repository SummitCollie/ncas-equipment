class Asset < ApplicationRecord
  acts_as_ordered_taggable

  belongs_to :location, optional: true
  belongs_to :user, optional: true
  has_and_belongs_to_many :checkouts
  has_and_belongs_to_many :checkins

  validates :name, presence: true
  validates :checkout_scan_required, inclusion: [true, false]

  after_commit :ensure_tag_colors_present, on: [:create, :update]

  def available_to_check_out?
    return false if locked
    return false if user.present?
    location.blank? || location.for_checkin?
  end

  def primary_tag_color
    tags.first&.color
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
