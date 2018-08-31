class EmailPreference < ActiveRecord::Base
  belongs_to :user
  enum status: { active: 0, permanent_bounce: 1 }

  validates_uniqueness_of :user

  def receive_email_notifications?
    active? && receive_notifications?
  end
end
