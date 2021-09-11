module Admin
  class SearchController < Admin::ApplicationController
    def index
      authorize(:asset, :index?)
    end
  end
end
