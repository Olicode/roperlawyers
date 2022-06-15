class AddMoreFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :poa_made_in_spain, :string
    add_column :users, :poa_for, :string
  end
end
