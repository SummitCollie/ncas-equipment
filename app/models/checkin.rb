class Checkin < ApplicationRecord
  has_and_belongs_to_many :assets
end
