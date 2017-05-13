class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :reporter_id, null: false
      t.integer :reported_id, null: false
      t.integer :reason, limit: 2, null: false
      t.boolean :resolved, null: false, default: false
      t.string :description, limit: 1000
      t.string :resolution, limit: 1000

      t.timestamps null: false
    end
  end
end
