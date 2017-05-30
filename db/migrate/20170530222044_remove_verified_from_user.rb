class RemoveVerifiedFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :verified, :boolean
  end
end
