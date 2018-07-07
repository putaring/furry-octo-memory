class RenameTransactionaltoReceiveNotifications < ActiveRecord::Migration
  def change
    rename_column :email_preferences, :transactional, :receive_notifications
  end
end
