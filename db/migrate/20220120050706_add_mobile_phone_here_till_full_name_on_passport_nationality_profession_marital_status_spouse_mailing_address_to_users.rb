class AddMobilePhoneHereTillFullNameOnPassportNationalityProfessionMaritalStatusSpouseMailingAddressToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mobile_phone, :string
    add_column :users, :here_till, :string
    add_column :users, :full_name_on_passport, :string
    add_column :users, :nationality, :string
    add_column :users, :profession, :string
    add_column :users, :marital_status, :string
    add_column :users, :spouse, :string
    add_column :users, :mailing_address, :string
  end
end
