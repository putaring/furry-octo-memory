class RemoveStatusFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :status
    remove_column :photos, :image
  end
end
