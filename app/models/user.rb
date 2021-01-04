class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable
  # :registerable, :validatable and :omniauthable
  devise :database_authenticatable, :rememberable

  has_many :checkouts
  has_many :orders
end
