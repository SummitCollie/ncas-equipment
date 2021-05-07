class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable
  # :registerable, :validatable
  devise :database_authenticatable, :omniauthable, :rememberable

  has_many :assets
  has_many :checkouts
  has_many :checkins
  has_many :magic_tokens

  before_validation :format_telegram_handle, if: -> { telegram.present? }

  validates :admin, inclusion: [true, false]
  validates :email, presence: true, uniqueness: true
  validates_uniqueness_of :telegram, allow_blank: true, case_sensitive: false

  def self.from_omniauth(access_token)
    data = access_token.info
    User.where(email: data['email']).first
  end

  private

  def format_telegram_handle
    telegram.strip!
    telegram.prepend('@') unless telegram.first == '@'
  end
end
