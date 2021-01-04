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

      t.timestamps
    end

    create_table :assets do |t|
      t.string :name, null: false
      t.text :description
      t.text :barcode, unique: true
      t.boolean :checkout_scan_required, null: false, default: false
      t.string :donated_by
      t.integer :est_value_cents

      t.timestamps
    end

    create_table :orders do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true

      t.timestamps
    end

    create_table :checkouts do |t|
      t.belongs_to :asset, null: false, index: true, foreign_key: true
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :order, null: false, index: true, foreign_key: true
      t.belongs_to :location, index: true, foreign_key: true
      t.datetime :est_return
      t.datetime :returned_at

      t.timestamps
    end
  end
end
