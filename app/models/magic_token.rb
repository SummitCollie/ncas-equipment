class MagicToken < ApplicationRecord
  belongs_to :user

  before_validation :assign_default_values, on: :create
  after_save :destroy_expired_tokens

  validates_presence_of :token
  validates_presence_of :expires
  validates_presence_of :purpose

  private

  def assign_default_values
    self.token = Devise.friendly_token
    self.expires = Time.current + 30.minutes unless expires.present?
  end

  def destroy_expired_tokens
    MagicToken.where('expires <= ?', Time.current).destroy_all
  end
end
