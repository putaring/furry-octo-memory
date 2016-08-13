module SessionsHelper
  def current_user
    @_current_user ||= session[:user_id] &&
      User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def logout
    session.delete(:user_id)
    @_current_user = nil
  end

  def login(user)
    session[:user_id] = user.id
  end
end
