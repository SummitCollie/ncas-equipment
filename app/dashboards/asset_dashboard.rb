require "administrate/base_dashboard"

class AssetDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    checkouts: Field::HasMany,
    orders: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    barcode: Field::Text,
    checkout_scan_required: Field::Boolean,
    donated_by: Field::String,
    est_value_cents: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  checkouts
  orders
  id
  name
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  checkouts
  orders
  id
  name
  description
  barcode
  checkout_scan_required
  donated_by
  est_value_cents
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  checkouts
  orders
  name
  description
  barcode
  checkout_scan_required
  donated_by
  est_value_cents
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how assets are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(asset)
  #   "Asset ##{asset.id}"
  # end
end
