class AddLastAdminUpdateSentAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_admin_update_sent_at, :datetime
  end
end
