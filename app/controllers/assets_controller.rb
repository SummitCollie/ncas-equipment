class AssetsController < ApplicationController
  def index
  end

  def search
    authorize(:asset, :show?)
    return head(:bad_request) unless params[:query].present?
    return head(:bad_request) if params[:scope].present? && ['can_check_in',
                                                             'can_check_out',].exclude?(params[:scope])

    search_scope = params[:scope].present? ? Asset.public_send(params[:scope]) : Asset.all
    assets = search_scope.where('name ILIKE ?', "%#{params[:query]}%").order(:name).limit(20)

    render(json: assets, methods: :primary_tag_color)
  end
end
