class AddWaterAndElectricityBillDocumentsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :water_bill_documents, :json
    add_column :users, :electricity_bill_documents, :json
  end
end
