class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :bookmarks, :users, column: :bookmarker_id
    add_foreign_key :bookmarks, :users, column: :bookmarked_id
    add_foreign_key :conversations, :users, column: :sender_id
    add_foreign_key :conversations, :users, column: :recipient_id
    add_foreign_key :interests, :users, column: :liker_id
    add_foreign_key :interests, :users, column: :liked_id
    add_foreign_key :messages, :users, column: :sender_id
    add_foreign_key :reports, :users, column: :reporter_id
    add_foreign_key :reports, :users, column: :reported_id
  end
end
