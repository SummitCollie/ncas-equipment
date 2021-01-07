class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable
  # :registerable, :validatable
  devise :database_authenticatable, :omniauthable, :rememberable

  has_many :checkouts
  has_many :orders

  validates :email, presence: true, uniqueness: true
  validates :display_name, uniqueness: true
  validates :admin, inclusion: [true, false]

  def self.from_omniauth(access_token)
    data = access_token.info
    User.where(email: data['email']).first
  end
end
