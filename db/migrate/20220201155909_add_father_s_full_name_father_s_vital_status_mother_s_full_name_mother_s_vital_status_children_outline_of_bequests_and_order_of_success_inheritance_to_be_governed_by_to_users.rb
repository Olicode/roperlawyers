class AddFatherSFullNameFatherSVitalStatusMotherSFullNameMotherSVitalStatusChildrenOutlineOfBequestsAndOrderOfSuccessInheritanceToBeGovernedByToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :father_s_full_name, :string
    add_column :users, :father_s_vital_status, :string
    add_column :users, :mother_s_full_name, :string
    add_column :users, :mother_s_vital_status, :string
    add_column :users, :children, :string
    add_column :users, :outline_of_bequests_and_oder_of_success, :string
    add_column :users, :inheritance_to_be_governed_by, :string
  end
end
