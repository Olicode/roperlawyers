class AddBankAccountOpeningAndTaxIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :bank_account_opening, :boolean, default: false
    add_column :users, :home_tax_id_tin, :string
  end
end
