class AddSectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sect, :string, limit: 5
  end
end
