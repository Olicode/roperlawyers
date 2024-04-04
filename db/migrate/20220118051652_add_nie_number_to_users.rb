class AddNieNumberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nie_number, :string
  end
end
