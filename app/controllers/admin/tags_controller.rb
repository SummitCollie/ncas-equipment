module Admin
  class TagsController < Admin::ApplicationController
    def index
      @tags = ActsAsTaggableOn::Tag.all.order(:name)
    end
  end
end
