class RemoveHereTillFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :here_till, :string
  end
end
