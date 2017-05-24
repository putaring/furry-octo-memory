class CreatePhoneVerifications < ActiveRecord::Migration
  def change
    create_table :phone_verifications do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.inet :ip, null: false
      t.string :phone_number, limit: 30, null: false
      t.string :session_id, limit: 50
      t.integer :status, limit: 2, default: 0

      t.timestamps null: false
    end
  end
end
