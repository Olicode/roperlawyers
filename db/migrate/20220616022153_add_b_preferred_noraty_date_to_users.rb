class AddBPreferredNoratyDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :b_preferred_notary_date, :string
  end
end
