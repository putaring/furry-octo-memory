class RemoveRankFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :rank
  end
end
