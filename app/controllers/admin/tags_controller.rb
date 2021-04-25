module Admin
  class TagsController < Admin::ApplicationController
    def index
      @tags = ActsAsTaggableOn::Tag.all.order(:name)
    end

    def update
    end

    def destroy
      tag = ActsAsTaggableOn::Tag.find(params[:id])
      tag.destroy!
      head(:ok)
    end
  end
end
