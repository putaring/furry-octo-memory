class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  has_many :messages

  validates :sender, :recipient, presence: true
  validates_uniqueness_of :sender_id, scope: :recipient_id

  def other_participant(participant)
    @_other_participant ||= (participant.id == sender_id ? recipient : sender)
  end

  def self.with_participant(participant)
    where('conversations.sender_id = ? OR conversations.recipient_id = ?', participant.id, participant.id)
  end

  def self.between(sender_id, recipient_id)
    where('(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.recipient_id = ? AND conversations.sender_id = ?)',
      sender_id, recipient_id, sender_id, recipient_id).first
  end

end
