class AddStatusToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :status, :integer, limit: 2, null: false, default: 0

    # mark all existing photos as active / status = 1
    Photo.all.each { |p| p.update_attributes(status: 1) }
  end
end
