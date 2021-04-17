require 'administrate/field/base'

class TagListField < Administrate::Field::Base
  def selected_tags
    data.map do |tag|
      [tag.name, tag.id]
    end
  end

  def default_options
    (most_used_tags + selected_tags).uniq
  end

  def most_used_tags
    ActsAsTaggableOn::Tag.most_used(10).map do |tag|
      [tag.name, tag.id]
    end
  end
end
