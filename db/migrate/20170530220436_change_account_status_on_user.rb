class ChangeAccountStatusOnUser < ActiveRecord::Migration
  def change
    change_column :users, :account_status, :integer, limit: 2, null: false, default: 0
  end
end
