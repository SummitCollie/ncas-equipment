class Order < ApplicationRecord
  has_many :checkouts
  has_many :assets, through: :checkouts
  belongs_to :user
  belongs_to :location

  validates :user, presence: true
  validates_presence_of :checkouts
end
