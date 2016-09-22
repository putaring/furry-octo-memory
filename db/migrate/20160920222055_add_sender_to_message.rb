class AddSenderToMessage < ActiveRecord::Migration
  def change
    add_column    :messages, :sender_id, :integer, null: false
    rename_column :messages, :user_id, :recipient_id
    add_index :messages, :sender_id
  end
end
