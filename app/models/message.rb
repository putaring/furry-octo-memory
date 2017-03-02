class Message < ActiveRecord::Base
  belongs_to :sender, -> { where(account_status: User.account_statuses[:active]) }, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, -> { where(account_status: User.account_statuses[:active]) }, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :conversation

  validates :body, presence: true, length: { maximum: 1000 }

  scope :unread, -> { joins(:sender).where(read: false) }

end
