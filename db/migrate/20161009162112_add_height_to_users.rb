class AddHeightToUsers < ActiveRecord::Migration
  def change
    add_column :users, :height, :integer, limit: 2, null: false
  end
end
