class RemovePreferencesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :preferences
  end
end
