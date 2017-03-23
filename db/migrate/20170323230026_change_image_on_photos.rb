class ChangeImageOnPhotos < ActiveRecord::Migration
  def change
    change_column :photos, :image, :string, null: true
  end
end
