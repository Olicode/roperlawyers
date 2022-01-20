class AddDateOfBirthExpiryDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :expiry_date, :date
  end
end
