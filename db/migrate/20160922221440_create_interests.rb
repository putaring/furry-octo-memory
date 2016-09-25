class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :liker_id, null: false
      t.integer :liked_id, null: false
      t.boolean :rejected, null: false, default: false

      t.timestamps null: false
    end
    add_index :interests, :liker_id
    add_index :interests, :liked_id
    add_index :interests, [:liker_id, :liked_id], unique: true
  end
end
