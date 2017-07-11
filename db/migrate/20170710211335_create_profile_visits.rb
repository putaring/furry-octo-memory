class CreateProfileVisits < ActiveRecord::Migration
  def change
    create_table :profile_visits do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :visits, null: false
      t.date    :date, null: false

      t.timestamps null: false
    end
    add_foreign_key :profile_visits, :users, column: :visitor_id
    add_foreign_key :profile_visits, :users, column: :visited_id
    add_index :profile_visits, :visitor_id
    add_index :profile_visits, :visited_id
    add_index :profile_visits, [:visitor_id, :visited_id, :date], unique: true
  end
end
