class AddEscrituraToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :escritura, :string
  end
end
