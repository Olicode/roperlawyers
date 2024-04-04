class AddMotherSFirstNameFatherSFirstNameROriginBankDetailsOtbOriginBankDetailsBalanceBankDetailsStandingOrdersBankDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mother_s_first_name, :string
    add_column :users, :father_s_first_name, :string
    add_column :users, :r_origin_bank_details, :string
    add_column :users, :otb_origin_bank_details, :string
    add_column :users, :balance_bank_details, :string
    add_column :users, :standing_orders_bank_details, :string
  end
end
