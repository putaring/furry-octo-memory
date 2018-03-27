class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.references :user, index: true, foreign_key: true
      t.text :image_data

      t.timestamps null: false
    end
  end
end
