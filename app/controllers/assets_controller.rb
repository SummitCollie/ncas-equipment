class AssetsController < ApplicationController
  def index
  end

  def search
    authorize(:asset, :show?)
    return head(:bad_request) unless params[:query].present? || params[:filters].present?

    # TODO: paginate?
    assets = Asset.search_by_name(params[:query]).limit(200)

    render(json: assets, methods: :primary_tag_color)
  end
end
