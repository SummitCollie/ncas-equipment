require 'administrate/field/base'

class AssetListField < Administrate::Field::Base
  def selected_assets
    data
  end

  def default_options
    (selected_assets + Asset.order('RANDOM()').first(10)).uniq(&:id)
      .as_json(methods: :primary_tag_color)
  end

  private

  def with_primary_tag_colors(assets)
    assets.map(&:primary_tag_color)
  end
end
