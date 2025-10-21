class AddTaxRepresentativeFormToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :tax_representative_form, :string
  end
end
