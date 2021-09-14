module Admin
  class SearchController < Admin::ApplicationController
    def index
      authorize(:asset, :index?)

      @tags = ActsAsTaggableOn::Tag.all.order(:name)
      @users = User.all.order(:display_name)
      @locations = Location.all.order(:name)
    end
  end
end
