class AddSellingPropertyInCommunityToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :selling_property_in_community, :string
  end
end
