class AddPlaceOfBirthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :place_of_birth, :string
  end
end
