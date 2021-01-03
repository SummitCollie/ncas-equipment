# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_03_055940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "identifier"
    t.boolean "requires_scan", default: false, null: false
    t.boolean "checked_out", default: false, null: false
    t.bigint "current_location_id"
    t.datetime "est_return"
    t.string "donated_by"
    t.integer "est_value_cents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["current_location_id"], name: "index_assets_on_current_location_id"
  end

  create_table "assets_checkins", id: false, force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "checkin_id", null: false
  end

  create_table "assets_checkouts", id: false, force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "checkout_id", null: false
  end

  create_table "checkins", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "checkouts", force: :cascade do |t|
    t.datetime "est_return"
    t.bigint "location_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["location_id"], name: "index_checkouts_on_location_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.bigint "event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_locations_on_event_id"
  end

  add_foreign_key "assets", "locations", column: "current_location_id"
  add_foreign_key "checkouts", "locations"
  add_foreign_key "locations", "events"
end
