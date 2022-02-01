class AddTaxResidentToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tax_resident, :boolean, default: false, null: false
  end
end
