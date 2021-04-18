class TagsController < ApplicationController
  def search
    authorize(:tag, :index?)
    return head(:bad_request) unless params[:query].present?

    puts params[:query]
    results = ActsAsTaggableOn::Tag.named_like(params[:query]).limit(50)
    render(json: results)
  end
end
