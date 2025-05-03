class AddEnergyEfficiencyCertificateCeeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :energy_efficiency_certificate_cee, :string
  end
end
