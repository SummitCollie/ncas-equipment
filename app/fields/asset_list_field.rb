require 'administrate/field/base'

class AssetListField < Administrate::Field::Base
  def selected_assets
    data
  end
end
