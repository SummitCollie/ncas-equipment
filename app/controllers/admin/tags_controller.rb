module Admin
  class TagsController < Admin::ApplicationController
    def index
      @tags = ActsAsTaggableOn::Tag.all.order(:name)
    end

    def update
      tag = ActsAsTaggableOn::Tag.find(params[:id])
      if tag.update(
        params.require(:tag).permit(
          Pundit.policy(current_user, :tags).permitted_attributes
        )
      )
        head(:ok)
      else
        head(:unauthorized)
      end
    end

    def destroy
      tag = ActsAsTaggableOn::Tag.find(params[:id])
      tag.destroy!
      head(:ok)
    end
  end
end
