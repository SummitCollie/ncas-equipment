class CreateInitialTables < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    create_table :locations do |t|
      t.string :name
      t.belongs_to :event, null: false, foreign_key: true
      t.boolean :for_checkout
      t.boolean :for_checkin

      t.timestamps
    end

    create_table :assets do |t|
      t.string :name, null: false
      t.text :description
      t.belongs_to :location, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.text :barcode, unique: true
      t.boolean :locked, null: false, default: false
      t.boolean :checkout_scan_required, null: false, default: false
      t.string :donated_by
      t.integer :est_value_cents

      t.timestamps
    end

    create_table :checkouts do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :location, index: true, foreign_key: true
      t.datetime :est_return

      t.timestamps
    end

    create_table :assets_checkouts do |t|
      t.belongs_to :asset, null: false, foreign_key: true
      t.belongs_to :checkout, null: false, foreign_key: true

      t.timestamps
    end

    create_table :checkins do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :location, foreign_key: true
      t.datetime :returned_at

      t.timestamps
    end

    create_table :assets_checkins do |t|
      t.belongs_to :asset, null: false, foreign_key: true
      t.belongs_to :checkin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
