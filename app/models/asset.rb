class Asset < ApplicationRecord
  acts_as_ordered_taggable

  belongs_to :location, optional: true
  belongs_to :user, optional: true
  has_and_belongs_to_many :checkouts
  has_and_belongs_to_many :checkins

  validates :name, presence: true
  validates :checkout_scan_required, inclusion: [true, false]

  after_commit :ensure_tag_colors_present, on: [:create, :update]

  scope :can_check_out, -> {
    where(locked: false, user_id: nil, location_id: nil)
  }
  scope :can_check_in, -> {
    # Not the inverse of above, because we want locked assets to be check-in-able
    # where.not(id: can_check_out)
    where.not(user_id: nil, location_id: nil)
  }

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
