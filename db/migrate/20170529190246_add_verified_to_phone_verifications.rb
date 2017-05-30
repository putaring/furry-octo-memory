class AddVerifiedToPhoneVerifications < ActiveRecord::Migration
  def change
    add_column :phone_verifications, :verified, :boolean, default: false, null: false
  end
end
