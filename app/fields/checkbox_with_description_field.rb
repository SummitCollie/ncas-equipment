require "administrate/field/base"

class CheckboxWithDescriptionField < Administrate::Field::Base
  def to_s
    data
  end
end
