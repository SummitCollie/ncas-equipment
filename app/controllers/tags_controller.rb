class TagsController < ApplicationController
  def search
    authorize(:tags, :index?)
    return head(:bad_request) unless params[:query].present?

    results = ActsAsTaggableOn::Tag.named_like(params[:query]).order(:name).limit(20)
    render(json: results)
  end
end
