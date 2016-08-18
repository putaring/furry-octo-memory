class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :about, limit: 1500
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
