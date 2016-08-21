class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image, null: false
      t.integer :rank, limit: 2, null: false
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
