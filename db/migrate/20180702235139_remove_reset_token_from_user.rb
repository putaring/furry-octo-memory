class RemoveResetTokenFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :reset_token
  end
end
