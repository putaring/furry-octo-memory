class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column  :gender, "char(1)", null: false
      t.date    :birthdate, null: false
      t.integer :religion, limit: 2, null: false
      t.column  :language, "char(2)", null: false
      t.column  :country, "char(2)", null: false
      t.string  :username, limit: 30,null: false
      t.string  :email, limit: 60, null: false
      t.string  :password_digest, limit: 60, null: false

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
