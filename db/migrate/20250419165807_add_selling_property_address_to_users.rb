class AddSellingPropertyAddressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :selling_property_address, :text
  end
end
