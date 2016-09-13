class AddPreferencesToUser < ActiveRecord::Migration
  def change
    add_column :users, :preferences, :jsonb, null: false, default: '{}'
  end
end
