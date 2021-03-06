module UsersHelper
  def metric_height(height_in_inches)
    feet    = "#{height_in_inches / 12} ft"
    inches  = (height_in_inches % 12 == 0) ? "" : "#{height_in_inches % 12} in"
    "#{feet} #{inches}".strip
  end

  def is_me?(user)
    user.eql?(current_user)
  end

  def reset_token_for(user)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
    verifier.generate([user.id, 2.hours.from_now])
  end
end
