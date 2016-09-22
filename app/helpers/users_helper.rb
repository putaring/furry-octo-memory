module UsersHelper
  def can_send_message_to?(user)
    logged_in? && !(current_user == user)
  end
end
