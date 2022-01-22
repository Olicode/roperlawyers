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

ActiveRecord::Schema.define(version: 2022_01_22_060533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "passport_number"
    t.string "email"
    t.string "sf_contact_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nie_number"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
