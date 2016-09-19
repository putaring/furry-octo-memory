class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  validates :body, presence: true, length: { maximum: 1000}
end
