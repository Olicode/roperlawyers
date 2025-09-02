class AddFxQuoteReferralConsentToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :fx_quote_referral_consent, :boolean
  end
end
