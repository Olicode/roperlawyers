class AddBuyingPropertyAddressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :buying_property_address, :text
  end
end
