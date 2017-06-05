class AddIpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ip, :inet
    add_column :photos, :ip, :inet
    add_column :messages, :ip, :inet

    User.update_all(ip: "127.0.0.1")
    Photo.update_all(ip: "127.0.0.1")
    Message.update_all(ip: "127.0.0.1")

    change_column_null :users, :ip, false
    change_column_null :photos, :ip, false
    change_column_null :messages, :ip, false
  end
end
