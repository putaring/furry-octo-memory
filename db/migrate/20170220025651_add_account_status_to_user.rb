class AddAccountStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_status, :integer, limit: 2, null: false, default: 1
  end
end
