class TagsController < ApplicationController
  def search
    authorize(:tag, :index?)
    head(:ok)
  end
end
