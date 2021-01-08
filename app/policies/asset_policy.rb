class AssetPolicy < ApplicationPolicy
  attr_reader :user, :asset

  def initialize(user, asset)
    @user = user
    @asset = asset
  end
end
