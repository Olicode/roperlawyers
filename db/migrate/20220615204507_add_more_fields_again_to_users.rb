class AddMoreFieldsAgainToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :home_address, :string
    add_column :users, :currency, :string
    add_column :users, :needs_nie, :string
    add_column :users, :needs_mortgage, :string
    add_column :users, :wants_to_holiday_let, :string
    add_column :users, :has_a_spanish_bank_account, :string
  end
end
