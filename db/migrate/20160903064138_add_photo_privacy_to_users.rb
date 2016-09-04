class AddPhotoPrivacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo_visibility, :integer, limit: 2, null: false, default: 1
  end
end
