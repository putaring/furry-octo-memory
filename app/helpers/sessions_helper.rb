module SessionsHelper
  def current_user
    @_current_user ||= cookies.signed[:auth_token] &&
      User.find_by(id: cookies.signed[:auth_token])
  end

  def logged_in?
    current_user.present?
  end

  def logout
    cookies.delete(:auth_token)
    @_current_user = nil
  end

  def login(user)
    cookies.permanent.signed[:auth_token] = user.id
  end
end
