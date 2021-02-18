class Order < ApplicationRecord
  attr_accessor :for_user, :for_location, :for_assets

  has_many :checkouts
  has_many :assets, through: :checkouts
  belongs_to :user

  validates :user, presence: true

  before_validation :create_checkouts, on: :create

  private

  def create_checkouts
    if @for_assets.empty?
      raise ActiveRecord::RecordInvalid.new(self), 'no assets added'
    end

    # Admins can create Orders on behalf of other users
    user = user.admin? ? User.find(@for_user) : user

    @for_assets.each do |id|
      checkouts.create(asset: id, user: user, location: @for_location)
    end
  end
end
