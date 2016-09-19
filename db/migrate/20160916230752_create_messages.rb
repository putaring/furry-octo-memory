class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body, limit: 1000, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :conversation, index: true, foreign_key: true, null: false
      t.boolean :read, default: false, null: false

      t.timestamps null: false
    end
  end
end
