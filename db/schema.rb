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

ActiveRecord::Schema[7.1].define(version: 2023_01_18_191153) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "passport_number"
    t.string "email"
    t.string "sf_contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nie_number"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.date "date_of_birth"
    t.date "expiry_date"
    t.string "mobile_phone"
    t.string "full_name_on_passport"
    t.string "nationality"
    t.string "profession"
    t.string "marital_status"
    t.string "spouse"
    t.string "mailing_address"
    t.string "mother_s_first_name"
    t.string "father_s_first_name"
    t.string "r_origin_bank_details"
    t.string "otb_origin_bank_details"
    t.string "balance_bank_details"
    t.string "standing_orders_bank_details"
    t.date "here_till"
    t.string "name_of_the_present_spouse"
    t.string "name_of_the_previous_spouses"
    t.date "date_of_divorce"
    t.date "date_of_decease"
    t.string "needs_poa"
    t.boolean "tax_resident", default: false, null: false
    t.string "father_s_full_name"
    t.string "father_s_vital_status"
    t.string "mother_s_full_name"
    t.string "mother_s_vital_status"
    t.string "children"
    t.string "outline_of_bequests_and_oder_of_success"
    t.string "inheritance_to_be_governed_by"
    t.string "poa_made_in_spain"
    t.string "poa_for"
    t.string "home_address"
    t.string "currency"
    t.string "needs_nie"
    t.string "needs_mortgage"
    t.string "wants_to_holiday_let"
    t.string "has_a_spanish_bank_account"
    t.string "b_preferred_notary_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
