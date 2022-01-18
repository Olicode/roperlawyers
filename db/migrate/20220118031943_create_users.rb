class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :passport_number
      t.string :email
      t.string :sf_contact_id

      t.timestamps
    end
  end
end
