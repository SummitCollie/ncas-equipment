class AssetsController < ApplicationController
  def index
  end

  def search
    authorize(:asset, :show?)
    return head(:bad_request) unless params[:query].present?

    assets = Asset.where('name ILIKE ?', "%#{params[:query]}%").order(:name).limit(20)

    render(json: assets, methods: :primary_tag_color)
  end
end
