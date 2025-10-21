class AddSellerMortgageStatusToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :seller_mortgage_status, :string
  end
end
