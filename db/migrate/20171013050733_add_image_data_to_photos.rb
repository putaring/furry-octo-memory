class AddImageDataToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :image_data, :text
  end
end
