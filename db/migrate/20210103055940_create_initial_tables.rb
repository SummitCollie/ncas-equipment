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
      t.text :identifier, unique: true
      t.boolean :requires_scan, null: false, default: false
      t.boolean :checked_out, null: false, default: false
      t.belongs_to :current_location, index: true, foreign_key: { to_table: :locations }
      t.datetime :est_return
      t.string :donated_by
      t.integer :est_value_cents

      t.timestamps
    end

    create_table :checkouts do |t|
      t.datetime :est_return
      t.belongs_to :location, index: true, foreign_key: true

      t.timestamps
    end

    create_table :checkins do |t|
      t.timestamps
    end

    create_join_table :assets, :checkouts
    create_join_table :assets, :checkins
  end
end
