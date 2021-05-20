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

ActiveRecord::Schema.define(version: 2021_05_20_031101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "location_id"
    t.bigint "user_id"
    t.text "barcode"
    t.boolean "locked", default: false, null: false
    t.boolean "checkout_scan_required", default: false, null: false
    t.string "donated_by"
    t.integer "est_value_cents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["location_id"], name: "index_assets_on_location_id"
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "assets_checkins", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "checkin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_id"], name: "index_assets_checkins_on_asset_id"
    t.index ["checkin_id"], name: "index_assets_checkins_on_checkin_id"
  end

  create_table "assets_checkouts", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "checkout_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_id"], name: "index_assets_checkouts_on_asset_id"
    t.index ["checkout_id"], name: "index_assets_checkouts_on_checkout_id"
  end

  create_table "checkins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "location_id"
    t.datetime "returned_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["location_id"], name: "index_checkins_on_location_id"
    t.index ["user_id"], name: "index_checkins_on_user_id"
  end

  create_table "checkouts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "location_id"
    t.datetime "est_return"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["location_id"], name: "index_checkouts_on_location_id"
    t.index ["user_id"], name: "index_checkouts_on_user_id"
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
    t.boolean "for_checkout"
    t.boolean "for_checkin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_locations_on_event_id"
  end

  create_table "magic_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "expires", null: false
    t.string "purpose", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_magic_tokens_on_user_id"
  end

  create_table "sent_telegram_messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "message_id", null: false
    t.string "purpose", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sent_telegram_messages_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.string "color"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false, null: false
    t.string "display_name"
    t.boolean "active", default: true, null: false
    t.string "telegram"
    t.string "telegram_chat_id"
    t.index ["display_name"], name: "index_users_on_display_name", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "assets", "locations"
  add_foreign_key "assets", "users"
  add_foreign_key "assets_checkins", "assets"
  add_foreign_key "assets_checkins", "checkins"
  add_foreign_key "assets_checkouts", "assets"
  add_foreign_key "assets_checkouts", "checkouts"
  add_foreign_key "checkins", "locations"
  add_foreign_key "checkins", "users"
  add_foreign_key "checkouts", "locations"
  add_foreign_key "checkouts", "users"
  add_foreign_key "locations", "events"
  add_foreign_key "magic_tokens", "users"
  add_foreign_key "sent_telegram_messages", "users"
  add_foreign_key "taggings", "tags"
end
