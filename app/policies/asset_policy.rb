class AssetPolicy < ApplicationPolicy
  def permitted_attributes
    if user.admin?
      [
        :name,
        :description,
        :barcode,
        :checkout_scan_required,
        :donated_by,
        :est_value_cents,
        tag_list: [],
      ]
    end
  end
end
