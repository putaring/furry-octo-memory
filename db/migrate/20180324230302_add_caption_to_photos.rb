class AddCaptionToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :caption, :string, limit: 500
  end
end
