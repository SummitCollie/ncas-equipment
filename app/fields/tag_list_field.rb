require 'administrate/field/base'

class TagListField < Administrate::Field::Base
  def to_s
    data
  end
end
