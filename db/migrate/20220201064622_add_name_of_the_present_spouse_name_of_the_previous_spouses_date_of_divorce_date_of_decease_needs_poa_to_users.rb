class AddNameOfThePresentSpouseNameOfThePreviousSpousesDateOfDivorceDateOfDeceaseNeedsPoaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name_of_the_present_spouse, :string
    add_column :users, :name_of_the_previous_spouses, :string
    add_column :users, :date_of_divorce, :date
    add_column :users, :date_of_decease, :date
    add_column :users, :needs_poa, :string
  end
end
