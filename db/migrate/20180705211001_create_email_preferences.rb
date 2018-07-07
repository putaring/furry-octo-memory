class CreateEmailPreferences < ActiveRecord::Migration
  def change
    create_table :email_preferences do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.boolean :transactional, null: false, default: true

      t.timestamps null: false
    end
  end
end
