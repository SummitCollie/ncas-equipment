require 'administrate/field/base'

class TagListField < Administrate::Field::Base
  def selected_tags
    data
  end

  def default_options
    (selected_tags + most_used_tags).uniq
  end

  def most_used_tags
    ActsAsTaggableOn::Tag.most_used(10).map(&:name)
  end
end
