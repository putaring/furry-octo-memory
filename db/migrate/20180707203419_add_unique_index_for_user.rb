class AddUniqueIndexForUser < ActiveRecord::Migration
  def change
    remove_index :profiles, :user_id
    remove_index :email_preferences, :user_id
    add_index :profiles, :user_id, unique: true
    add_index :email_preferences, :user_id, unique: true

  end
end
