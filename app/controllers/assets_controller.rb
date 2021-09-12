class AssetsController < ApplicationController
  def index
  end

  # Used for quick asset search on Check-Out/Check-In pages, etc.
  def search
    authorize(:asset, :show?)
    return head(:bad_request) unless params[:query].present?

    assets = Asset.search_by_name(params[:query]).limit(20)

    render(json: assets, methods: :primary_tag_color)
  end

  # For the big global search page, includes data for location/user/tags/etc
  def global_search
    authorize(:asset, :show?)
    return render(body: nil) unless params[:query].present? || params[:filters].present?

    assets = Asset.search_by_name(params[:query]).limit(200)

    return render(body: nil) if assets.empty?

    locations = assets.map(&:location).filter(&:present?).uniq
    users = assets.map(&:user).filter(&:present?).uniq
    tags = assets.map(&:tags).filter(&:present?).flatten.uniq

    render(json: {
      assets: assets,
      locations: locations,
      users: users,
      tags: tags,
    })
  end
end
