class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer, limit: 2, null: false
  end
end
