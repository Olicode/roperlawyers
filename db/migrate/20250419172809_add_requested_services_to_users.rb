class AddRequestedServicesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :requested_services, :text
  end
end
