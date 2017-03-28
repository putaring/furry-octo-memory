class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :bookmarker_id, null: false
      t.integer :bookmarked_id, null: false

      t.timestamps null: false
    end
    add_index :bookmarks, :bookmarker_id
    add_index :bookmarks, :bookmarked_id
    add_index :bookmarks, [:bookmarker_id, :bookmarked_id], unique: true
  end
end
