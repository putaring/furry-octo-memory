class AddTriesToPhoneVerification < ActiveRecord::Migration
  def change
    add_column :phone_verifications, :tries, :integer, limit: 2, default: 1, null: false
  end
end
