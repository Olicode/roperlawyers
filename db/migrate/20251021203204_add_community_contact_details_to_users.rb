class AddCommunityContactDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :community_contact_details, :text
  end
end
