class RemoveStatusFromPhoneVerifications < ActiveRecord::Migration
  def change
    remove_column :phone_verifications, :status, :integer, limit: 2
  end
end
