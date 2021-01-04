class Order < ApplicationRecord
  has_many :checkouts
  has_many :assets, through: :checkouts
  belongs_to :user
end
