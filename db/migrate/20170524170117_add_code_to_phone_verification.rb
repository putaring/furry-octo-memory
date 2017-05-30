class AddCodeToPhoneVerification < ActiveRecord::Migration
  def change
    add_column :phone_verifications, :code, :string, limit: 10, null: false
  end
end
